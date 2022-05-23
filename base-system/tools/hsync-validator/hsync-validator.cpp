#include "date.h"
#include <fstream>
#include <functional>
#include <iostream>
#include <map>
#include <sstream>
#include <vector>

struct Line {
	int line_number;
	std::string line;

	Line () {}
	Line (const int &line_number, const std::string& line) : 
		line_number(line_number), 
		line(line) {}
};

#define ERR std::cout << "Error: "
#define ERROR(line_number) std::cout << "Error in " << line_number << "-th line: "

// -------------- Value format checkers ----------------
std::function<bool(const std::string&)> url_address =
		[] (const std::string& url) -> bool {
	std::string command = "/usr/lib/hsync/url_validator " + url;
	return system(command.c_str()) == 0;
};

std::function<bool(const std::string&)> time_zone =
		[] (const std::string &time_zone) -> bool {
	std::string command = "/usr/lib/hsync/timezone_validator " + time_zone;
	return system(command.c_str()) == 0;
};

std::function<bool(const std::string&)> keyboard_layout =
		[] (const std::string &keyboard_layout) -> bool {
	std::string command = "/usr/lib/hsync/layout_validator " + keyboard_layout;
	return system(command.c_str()) == 0;
};

std::function<bool(const std::string&)> software =
		[] (const std::string &software) -> bool {
	std::string command = "/usr/lib/hsync/software_validator " + software;
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

	while (std::getline(ss, element, '|')) {
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

bool is_valid_pair (const std::string& value) {
	if (value.empty()) {
		return false;
	}

	int cnt = 0;
	for (const char &c : value) {
		if (c == '^') {
			cnt++;
		}
	}

	return value[0] == '{' && value.back() == '}' && cnt == 1;
}

std::pair<std::string, std::string> get_pair (std::string value) {
	for (char c : "{}^") {
		std::replace(value.begin(), value.end(), c, ' ');
	}

	std::istringstream ss(value);
	std::string first, second;

	ss >> first >> second;
	return std::make_pair(first, second);
}

std::function<bool(const std::string&, const std::pair<
	const std::function<bool(const std::string&)>&, 
	const std::function<bool(const std::string&)>&>)> list_of_pairs =
		[] (const std::string& value, const std::pair<
				const std::function<bool(const std::string&)>&, 
				const std::function<bool(const std::string&)>&> fun_pair) -> bool {
	const auto list = value_to_list(value);

	for (const auto &element : list) {
		if (!is_valid_pair(element)) {
			return false;
		}

		auto [first, second] = get_pair(element);
		if (!fun_pair.first(first) || !fun_pair.second(second)) {
			return false;
		}
	}

	return true;
};
// -----------------------------------------------------

// --------------- Line reading utils ------------------
bool is_group_header (const std::string& line, const std::string &group_name) {
	return line == "[" + group_name + "]";
}

void error_variable_value (const Line& line) {
	ERROR(line.line_number) << "Variable definition invalid" << std::endl;
}

std::string get_variable (const Line& line) {
	size_t found = line.line.find("=");
	if (found == std::string::npos) {
		error_variable_value(line);
	}

	return line.line.substr(0, found);
}

std::string get_value (const Line& line) {
	size_t found = line.line.find("=");
	if (found == std::string::npos) {
		error_variable_value(line);
	}

	return line.line.substr(found + 1);
}

std::map<std::string, Line> get_variables (const std::vector<Line>& lines) {
	std::map<std::string, Line> variables;

	for (const auto &line : lines) {
		size_t space_pos = line.line.find(' ');
		if (space_pos != std::string::npos) {
			ERROR(line.line_number) << "Extra space found" << std::endl;
			exit(1);
		}

		variables[get_variable(line)] = line;
	}

	return variables;
}

std::vector<Line> get_group (const std::string &filename, const std::string& group_name) {
	std::ifstream infile(filename);
	std::vector<Line> lines;
	std::string line;

	bool group_found = false;
	for (int i = 1; getline(infile, line); i++) {
		if (line.empty()) {
			continue;
		}

		if (group_found) {
			if (line[0] == '[') {
				break;
			}

			lines.emplace_back(i, line);
		} else {
			if (is_group_header(line, group_name)) {
				group_found = true;
			}
		}
	}

	if (!group_found) {
		ERR << "Group " << group_name << " not found" << std::endl;
		exit(1);
	}

	return lines;
}
// --------------------------------------------------------

// -------------- Time range checker ----------------------
void time_range_error (int line_number) {
	ERROR(line_number) << "Invalid time range" << std::endl;
	exit(1);
}

date::local_seconds get_timestamp (const std::string& date, int line_number) {
	date::local_seconds timestamp;

	std::istringstream in(date);
	in >> date::parse("%FT%T", timestamp);

	if (in.fail()) {
		time_range_error(line_number);
	}

	return timestamp;
}

using time_range = std::pair<date::local_seconds, date::local_seconds>;
std::vector<time_range> mode_times (
		const std::string& filename, 
		const std::string& mode_name, 
		bool expected_exactly_one) {
	const auto lines = get_group(filename, mode_name + "-Times");

	std::vector<time_range> ranges;
	std::string line;

	for (const auto& line : lines) {
		std::stringstream ss(line.line);
		std::string start, end;

		if (!(ss >> start >> end)) {
			time_range_error(line.line_number);
		}

		auto start_ts = get_timestamp(start, line.line_number);
		auto end_ts = get_timestamp(end, line.line_number);

		if (start_ts >= end_ts) {
			time_range_error(line.line_number);
		}

		ranges.emplace_back(start_ts, end_ts);
	}

	if (expected_exactly_one) {
		if (ranges.size() != 1) {
			ERR << "Expected 1 time range but found " 
				<< ranges.size() 
				<< " time ranges for mode " 
				<< mode_name 
				<< std::endl;
		}
	} else {
		if (ranges.size() < 1) {
			ERR << "Expected at least 1 time range but found " 
				<< ranges.size() 
				<< " time ranges for mode " 
				<< mode_name 
				<< std::endl;
		}
	}

	return ranges;
}

void check_valid_ranges (
		const std::vector<time_range>& event_time, 
		const std::vector<time_range>& contest_times) {
	for (size_t i = 0; i < contest_times.size(); i++) {
		if (!(
				event_time[0].first <= contest_times[i].first && 
				contest_times[i].second <= event_time[0].second)) {
			std::cout << "Error: " 
					  << i + 1 
					  << "-th contest does not happen during event" 
					  << std::endl;
			exit(1);
		}

		if (0 < i && !(contest_times[i - 1].second < contest_times[i].first)) {
			std::cout << "Error: " 
					  << i + 1 
					  << "-th does not happen after " 
					  << i 
					  << "-th contest ends" 
					  << std::endl;
			exit(1);
		}
	}
}
// --------------------------------------------------------------

// ------------ Variable declaration checkers -------------------
const Line& get_line_for_variable (
		const std::map<std::string, Line>& variables,
		const std::string& variable) {
	if (variables.count(variable) == 0) {
		ERR << "Definition of variable " << variable << " not found" << std::endl;
		exit(0);
	}

	return variables.at(variable);
} 

void check_time_zone (const std::map<std::string, Line>& variables) {
	// Format: TimeZone=Continent/City
	const auto& line = get_line_for_variable(variables, "TimeZone");
	const auto value = get_value(line);

	if (!time_zone(value)) {
		ERROR(line.line_number) << "Time zone not valid" << std::endl;
		exit(1);
	}
}

void check_expiration_time (const std::map<std::string, Line>& variables) {
	// Format: ConfigExpirationTime=[ never || GNU Time ]
	const auto& line = get_line_for_variable(variables, "ConfigExpirationTime");
	const auto value = get_value(line);

	if (!exact_value(value, "never") && !date_in_iso8601(value)) {
		ERROR(line.line_number) << "Expiration time not valid" << std::endl;
		exit(1);
	}
}

std::vector<std::string> check_available_layouts (const std::map<std::string, Line>& variables) {
	// Format: AvailableKeyboardLayouts=layout1|layout2|...|
	const auto& line = get_line_for_variable(variables, "AvailableKeyboardLayouts");
	const auto value = get_value(line);

	if (!list_of_values(value, keyboard_layout)) {
		ERROR(line.line_number) << "Keyboard layout not valid" << std::endl;
		exit(1);
	}

	return value_to_list(value);
}

void check_default_layout (
		const std::map<std::string, Line>& variables, 
		const std::vector<std::string> &available_layouts) {
	// Format: DefaultKeyboardLayout=layout
	const auto& line = get_line_for_variable(variables, "DefaultKeyboardLayout");
	const auto value = get_value(line);

	if (std::find(available_layouts.begin(), available_layouts.end(), value) == available_layouts.end()) {
		ERROR(line.line_number) << "Layout not in available layouts" << std::endl;
		exit(1);
	}
}

bool check_event_config (const std::map<std::string, Line>& variables) {
	// Format: EventConfig=[ true || false ]
	const auto& line = get_line_for_variable(variables, "EventConfig");
	const auto value = get_value(line);

	if (!exact_value(value, "true") && !exact_value(value, "false")) {
		ERROR(line.line_number) << "Event config not valid" << std::endl;
		exit(1);
	}

	return value == "true";
}

bool check_contest_config (const std::map<std::string, Line>& variables) {
	// Format: ContestConfig=[ true || false ]
	const auto& line = get_line_for_variable(variables, "ContestConfig");
	const auto value = get_value(line);

	if (!exact_value(value, "true") && !exact_value(value, "false")) {
		ERROR(line.line_number) << "Contest config not valid" << std::endl;
		exit(1);
	}

	return value == "true";
}

void check_wallpaper (const std::map<std::string, Line>& variables) {
	// Format: Wallpaper=[ default || url ]
	const auto& line = get_line_for_variable(variables, "Wallpaper");
	const auto value = get_value(line);

	if (!exact_value(value, "default") && !list_of_values(value, url_address)) {
		ERROR(line.line_number) << "Wallpaper declaration not valid or url not recheable" << std::endl;
		exit(1);
	}
}

void check_usb_storage_config (const std::map<std::string, Line>& variables) {
	// Format: AllowUsbStorage=[ true || false ]
	const auto& line = get_line_for_variable(variables, "AllowUsbStorage");
	const auto value = get_value(line);

	if (!exact_value(value, "true") && !exact_value(value, "false")) {
		ERROR(line.line_number) << "Allow USB storage config not valid" << std::endl;
		exit(1);
	}
}

void check_allow_list (const std::map<std::string, Line>& variables) {
	// Format: AllowedWebsites=[ all || any || url1|url2|...| ]
	const auto& line = get_line_for_variable(variables, "AllowedWebsites");
	const auto value = get_value(line);

	if (!exact_value(value, "all") && !exact_value(value, "any") && !list_of_values(value, url_address)) {
		ERROR(line.line_number) << "Allow list config not valid or url not recheable" << std::endl;
		exit(1);
	}
}

void check_bookmarks (const std::map<std::string, Line>& variables) {
	// Format: Bookmarks={first1^second1}|{first2^second2}|..|
	const auto& line = get_line_for_variable(variables, "Bookmarks");
	const auto value = get_value(line);

	if (!list_of_pairs(value, std::make_pair(any_value, url_address))) {
		ERROR(line.line_number) << "Bookmarks declaration not valid" << std::endl;
		exit(1);
	}
}

void check_available_software (const std::map<std::string, Line>& variables) {
	// Format: AvailableSoftware=software1|software2|...|
	const auto& line = get_line_for_variable(variables, "AvailableSoftware");
	const auto value = get_value(line);

	if (!list_of_values(value, software)) {
		ERROR(line.line_number) << "Software name not valid" << std::endl;
		exit(1);
	}
}
// -------------------------------------------------------------

void check_mode_config (const std::string& filename, const std::string& mode_name) {
	const auto lines = get_group(filename, mode_name);
	const auto variables = get_variables(lines);

	check_wallpaper(variables);
	check_usb_storage_config(variables);
	check_allow_list(variables);
	check_bookmarks(variables);
	check_available_software(variables);
}

void check_valid_file (std::string filename) {
	// Global config
	const auto global_lines = get_group(filename, "Global");
	const auto global_variables = get_variables(global_lines);

	check_time_zone(global_variables);
	check_expiration_time(global_variables);
	auto available_layouts = check_available_layouts(global_variables);
	check_default_layout(global_variables, available_layouts);
	bool is_event_set = check_event_config(global_variables);
	bool is_contest_set = check_contest_config(global_variables);

	// Always config
	check_mode_config(filename, "Always");

	// Event config
	std::vector<time_range> event_time;
	if (is_event_set) {
		check_mode_config(filename, "Event");
		event_time = mode_times(filename, "Event", true);
	}

	// Contest config
	std::vector<time_range> contest_times;
	if (is_contest_set) {
		check_mode_config(filename, "Contest");
		contest_times = mode_times(filename, "Contest", false);
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
