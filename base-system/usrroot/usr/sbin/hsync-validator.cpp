#include "date.h"
#include <fstream>
#include <functional>
#include <iostream>
#include <sstream>
#include <vector>

#define ERROR std::cout << "Error in " << line_counter << "-th line: "

int line_counter = 0;

std::istream& read_line (std::istream& infile, std::string& str) {
	line_counter++;
	return std::getline(infile, str);
}

// -------------- Value format checkers ----------------
std::function<bool(const std::string&)> url_address =
		[] (const std::string& url) -> bool {
	std::string command = "./url_validator " + url;
	return system(command.c_str()) == 0;
};

std::function<bool(const std::string&)> time_zone =
		[] (const std::string &time_zone) -> bool {
	std::string command = "./timezone_validator " + time_zone;
	return system(command.c_str()) == 0;
};

std::function<bool(const std::string&)> keyboard_layout =
		[] (const std::string &keyboard_layout) -> bool {
	std::string command = "./layout_validator " + keyboard_layout;
	return system(command.c_str()) == 0;
};

std::function<bool(const std::string&)> software =
		[] (const std::string &software) -> bool {
	std::string command = "./software_validator " + software;
	return system(command.c_str()) == 0;
};

std::function<bool(const std::string&)> date_in_iso8601 =
		[] (const std::string &date) -> bool {
	date::local_seconds timestamp;

	std::istringstream in(date);
	in >> date::parse("%FT%T", timestamp);

	return !in.fail();
};

std::function<bool(const std::string&)> any_value =
		[] (const std::string& _) -> bool {
	return true;
};

std::function<bool(const std::string&, const std::string &expected)> exact_value =
		[] (const std::string &value, const std::string &expected) -> bool {
	return value == expected;
};

std::vector<std::string> value_to_list (const std::string &value) {
	std::istringstream ss(value);
	std::vector<std::string> list;
	std::string element;

	while (std::getline(ss, element, ';')) {
		list.push_back(element);
	}

	return list;
}

std::function<bool(const std::string&, const std::function<bool(const std::string&)>&)> list_of_values =
		[] (const std::string &value, const std::function<bool(const std::string&)> &fun) -> bool {
	const auto list = value_to_list(value);

	for (const auto &element : list) {
		if (!fun(element)) {
			return false;
		}
	}

	return true;
};
// -----------------------------------------------------

// --------------- Header checker ----------------------
void group_header_error (const std::string &group_name) {
	ERROR << "Expected valid header for group " << group_name << std::endl;
	exit(1);
}

void group_header (std::ifstream &infile, const std::string &group_name) {
	std::string line;
	if (!read_line(infile, line)) {
		group_header_error(group_name);
	}

	if (line != "[" + group_name + "]") {
		group_header_error(group_name);
	}
}
// ------------------------------------------------------

// ----------- Key-value lines checker ------------------
void key_value_error (const std::string &key) {
	ERROR << "Expected valid key-value line for key " << key << std::endl;
	exit(1);
}

std::string key_value (std::ifstream &infile, const std::string &key) {
	std::string line;
	if (!read_line(infile, line)) {
		key_value_error(key);
	}

	size_t found = line.find("=");
	if (found == std::string::npos) {
		key_value_error(key);
	}

	std::string key_in_line = line.substr(0, found);
	if (key_in_line != key) {
		key_value_error(key); 
	}

	std::string value = line.substr(found + 1);
	return value;
}
// --------------------------------------------------------

// ------------- Blank line checker -----------------------
void blank_line_error () {
	ERROR << "Expected blank line" << std::endl;
	exit(1);
}

void blank_line (std::ifstream &infile) {
	std::string line;
	if (!read_line(infile, line) || !line.empty()) {
		blank_line_error();
	}
}
// --------------------------------------------------------

// -------------- Time range checker ----------------------
void time_range_error () {
	ERROR << "Expected valid time range" << std::endl;
	exit(1);
}

date::local_seconds get_timestamp (const std::string& date) {
	date::local_seconds timestamp;

	std::istringstream in(date);
	in >> date::parse("%FT%T", timestamp);

	if (in.fail()) {
		time_range_error();
	}

	return timestamp;
}

using time_range = std::pair<date::local_seconds, date::local_seconds>;
std::vector<time_range> mode_times (std::ifstream &infile, const std::string& mode_name, bool expected_exactly_one) {
	std::vector<time_range> ranges;
	std::string line;

	// [<mode_name>-Times]
	group_header(infile, mode_name + "-Times");

	while (read_line(infile, line)) {
		if (line.empty()) {
			break;
		}
		
		std::stringstream ss(line);
		std::string start, end;
		if (!(ss >> start >> end)) {
			time_range_error();
		}

		auto start_ts = get_timestamp(start);
		auto end_ts = get_timestamp(end);

		if (start_ts >= end_ts) {
			time_range_error();
		}

		ranges.emplace_back(start_ts, end_ts);
	}

	if (expected_exactly_one) {
		if (ranges.size() != 1) {
			ERROR << "Expected 1 time range but found " << ranges.size() << std::endl;
		}
	} else {
		if (ranges.size() < 1) {
			ERROR << "Expected at least 1 time range but found " << ranges.size() << std::endl;
		}
	}

	return ranges;
}

void check_valid_ranges (const std::vector<time_range>& event_time, const std::vector<time_range>& contest_times) {
	for (size_t i = 0; i < contest_times.size(); i++) {
		if (!(event_time[0].first <= contest_times[i].first && contest_times[i].second <= event_time[0].second)) {
			std::cout << "Error: " << i + 1 << "-th contest does not happen within event" << std::endl;
			exit(1);
		}

		if (0 < i && !(contest_times[i - 1].second < contest_times[i].first)) {
			std::cout << "Error: " << i + 1 << "-th does not happen after " << i << "-th contest ends" << std::endl;
			exit(1);
		}
	}
}
// --------------------------------------------------------------

// ----------------- Key-Value line checkers --------------------
void check_time_zone (std::ifstream &infile) {
	// Format: TimeZone=Continent/City
	auto value = key_value(infile, "TimeZone");

	if (!time_zone(value)) {
		ERROR << "Time zone not valid" << std::endl;
		exit(1);
	}
}

void check_expiration_time (std::ifstream &infile) {
	// Format: ConfigExpirationTime=[ never | GNU Time ]
	auto value = key_value(infile, "ConfigExpirationTime");

	if (!exact_value(value, "never") && !date_in_iso8601(value)) {
		ERROR << "Expiration time not valid" << std::endl;
		exit(1);
	}
}

std::vector<std::string> check_available_layouts (std::ifstream &infile) {
	// Format: AvailableKeyboardLayouts=layout1;layout2;...;
	auto value = key_value(infile, "AvailableKeyboardLayouts");

	if (!list_of_values(value, keyboard_layout)) {
		ERROR << "Keyboard layout not valid" << std::endl;
		exit(1);
	}

	return value_to_list(value);
}

void check_default_layout (std::ifstream &infile, const std::vector<std::string> &available_layouts) {
	// Format: DefaultKeyboardLayout=layout
	auto value = key_value(infile, "DefaultKeyboardLayout");

	if (std::find(available_layouts.begin(), available_layouts.end(), value) == available_layouts.end()) {
		ERROR << "Layout not in available layouts" << std::endl;
		exit(1);
	}
}

bool check_event_config (std::ifstream &infile) {
	// Format: EventConfig=[ True | False ]
	auto value = key_value(infile, "EventConfig");

	if (!exact_value(value, "true") && !exact_value(value, "false")) {
		ERROR << "Event config not valid" << std::endl;
		exit(1);
	}

	return value == "true";
}

bool check_contest_config (std::ifstream &infile) {
	// Format: ContestConfig=[ True | False ]
	auto value = key_value(infile, "ContestConfig");

	if (!exact_value(value, "true") && !exact_value(value, "false")) {
		ERROR << "Contest config not valid" << std::endl;
		exit(1);
	}

	return value == "true";
}

void check_wallpaper (std::ifstream &infile) {
	// Format: Wallpaper=[ default | url ]
	auto value = key_value(infile, "Wallpaper");

	if (!exact_value(value, "default") && !list_of_values(value, url_address)) {
		ERROR << "Wallpaper config not valid or url not recheable" << std::endl;
		exit(1);
	}
}

void check_allow_list (std::ifstream &infile) {
	// Format: AllowList=[ all | url1;url2;...; ]
	auto value = key_value(infile, "AllowList");

	if (!exact_value(value, "all") && !exact_value(value, "any") && !list_of_values(value, url_address)) {
		ERROR << "Allow list config not valid or url not recheable" << std::endl;
		exit(1);
	}
}

void check_available_software (std::ifstream &infile) {
	// Format: AvailableSoftware=software1;software2;...;
	auto value = key_value(infile, "AvailableSoftware");

	if (!list_of_values(value, software)) {
		ERROR << "Software name not valid" << std::endl;
		exit(1);
	}
}
// --------------------------------------------------------------

void check_mode_config (std::ifstream &infile, const std::string& mode_name) {
	// [<mode_name>]
	group_header(infile, mode_name);

	check_wallpaper(infile);
	check_allow_list(infile);
	check_available_software(infile);

	blank_line(infile);
}

void check_valid_file (std::string filename) {
	std::ifstream infile(filename);

	// [Global]
	group_header(infile, "Global");

	check_time_zone(infile);
	check_expiration_time(infile);
	auto available_layouts = check_available_layouts(infile);
	check_default_layout(infile, available_layouts);
	bool is_event_set = check_event_config(infile);
	bool is_contest_set = check_contest_config(infile);

	blank_line(infile);

	// [Always]
	check_mode_config(infile, "Always");

	std::vector<time_range> event_time;
	if (is_event_set) {
		// [Event]
		check_mode_config(infile, "Event");
		// [Event-times]
		event_time = mode_times(infile, "Event", true);
	}

	std::vector<time_range> contest_times;
	if (is_contest_set) {
		// [Contest]
		check_mode_config(infile, "Contest");
		// [Contest-times]
		contest_times = mode_times(infile, "Contest", false);
	}

	if (event_time.size() && contest_times.size()) {
		check_valid_ranges(event_time, contest_times);
	}
}

int main (int argc, char** argv) {
	if (argc < 2) {
		return 2;
	}

	check_valid_file(argv[1]);

	std::cout << "Valid sintax!" << std::endl;

	return 0;
}
