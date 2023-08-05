package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"time"
)

// Define the struct for sections
type Section struct {
	Content []ContentDirective
	Times   []TimeSpan
}

// Define the struct for content directive
type ContentDirective struct {
	DirectiveName string
	DirectiveVar  string
}

// Define the struct for time span
type TimeSpan struct {
	Begin string
	End   string
}

func parseLine(line string) (directive, content string, err error) {
	splitResult := strings.Split(line, "=")

	// Check if the split result contains exactly two parts
	if len(splitResult) != 2 {
		err = fmt.Errorf("invalid line format: %s", line)
		return
	}

	directive = splitResult[0]
	content = splitResult[1]
	return
}

func parseTimeSpan(line string) (begin, end string, err error) {
	timeParts := strings.Split(line, " ")
	if len(timeParts) != 2 {
		err = fmt.Errorf("invalid time span format: %s", line)
		return
	}

	begin = timeParts[0]
	end = timeParts[1]
	return
}

// Function to validate times format
func validateTimes(times []TimeSpan) bool {
	for _, timeSpan := range times {
		fmt.Printf("Validating %s and %s\n", timeSpan.Begin, timeSpan.End)
		_, err := time.Parse("2006-01-02T15:04:05", timeSpan.Begin)
		if err != nil {
			// Invalid begin time format
			return false
		}
		_, err = time.Parse("2006-01-02T15:04:05", timeSpan.End)
		if err != nil {
			// Invalid end time format
			return false
		}
	}
	return true
}

// Function to validate a content section
func validateContent(content []ContentDirective) bool {
	// Here validate the global and specific things but split in
	//GLOBAL CHECKS

	//Mode checks
	for _, directive := range content {
		fmt.Printf("Validating %s and %s\n", directive.DirectiveName, directive.DirectiveVar)
		// Global checks
		if directive.DirectiveName == "TimeZone" {
			//	Test against possible timezones
		}
		if directive.DirectiveName == "ConfigExpirationTime" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "AvailableKeyboardLayouts" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "DefaultKeyboardLayout" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "EventConfig" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "ContestConfig" {
			//	Test against possible values / regex
		}

		// Specific mode checks
		if directive.DirectiveName == "AllowedWebsites" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "AllowUsbStorage" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "AvailableSoftware" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "Bookmarks" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "Wallpaper" {
			//	Test against possible values / regex
		}
		if directive.DirectiveName == "WallpaperSha256" {
			//	Test against possible values / regex
		}

	}
	return true
}

func main() {
	// Read the file
	file, err := os.Open("cpci.hdf")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	// Create a map to store sections with struct values
	sectionMap := make(map[string]Section)

	// Read the file line by line
	scanner := bufio.NewScanner(file)
	var currentSection string
	for scanner.Scan() {
		line := scanner.Text()

		// Skip empty lines and comments
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		// Check if the line is a section header
		if strings.HasPrefix(line, "[") && strings.HasSuffix(line, "]") {
			currentSection = strings.TrimPrefix(strings.TrimSuffix(line, "]"), "[")
			continue
		}

		// Check if the section ends with -Times
		if strings.HasSuffix(currentSection, "-Times") {
			// Add the line to the corresponding section's Times
			sectionName := strings.TrimSuffix(currentSection, "-Times")
			// Retrieve the current section value from the map
			currentSectionValue := sectionMap[sectionName]
			// Modify the Times field of the struct
			begin, end, err := parseTimeSpan(line)
			if err != nil {
				fmt.Println("Error parsing time span:", err)
				return
			}
			currentSectionValue.Times = append(currentSectionValue.Times, TimeSpan{Begin: begin, End: end})
			// Update the map with the modified section value
			sectionMap[sectionName] = currentSectionValue
		} else if currentSection != "" {
			// Retrieve the current section value from the map
			currentSectionValue := sectionMap[currentSection]
			// Modify the Content field of the struct
			directive, content, err := parseLine(line)
			if err != nil {
				fmt.Println("Error parsing line:", err)
				return
			}
			currentSectionValue.Content = append(currentSectionValue.Content, ContentDirective{DirectiveName: directive, DirectiveVar: content})
			// Update the map with the modified section value
			sectionMap[currentSection] = currentSectionValue
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading file:", err)
		return
	}

	// Validate sections and print validation results
	for section, data := range sectionMap {
		switch section {
		case "Global":
			if validateContent(data.Content) {
				fmt.Println("Global validation: Passed")
			} else {
				fmt.Println("Global validation: Failed")
			}
		case "Always":
			if validateContent(data.Content) {
				fmt.Println("Always validation: Passed")
			} else {
				fmt.Println("Always validation: Failed")
			}
		case "Event":
			if validateContent(data.Content) && validateTimes(data.Times) {
				fmt.Println("Event validation: Passed")
			} else {
				fmt.Println("Event validation: Failed")
			}
		case "Contest":
			if validateContent(data.Content) && validateTimes(data.Times) {
				fmt.Println("Contest validation: Passed")
			} else {
				fmt.Println("Contest validation: Failed")
			}
		}
	}
}
