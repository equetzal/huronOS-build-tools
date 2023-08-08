package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
	"time"
)

// Create a map to store sections with struct values
var sectionMap = make(map[string]Section)
var availableLayouts []string
var availableTimezones []string
var availableSoftware []string

// Define the struct for sections
type Section struct {
	SectionDirectives map[string]string
	Times             []TimeSpan
	Warnings          []string
}

// Define the struct for time span
type TimeSpan struct {
	Begin string
	End   string
}

// Warnings section
func addEmptyDirectiveWarning(section, directiveName string) {
	addWarning(section, fmt.Sprintf("Empty directive: %s\nDirective either not defined or empty\n", directiveName))
}

func addInvalidDirectiveValueWarning(section, directiveName, directiveValue string) {
	addWarning(section, fmt.Sprintf("Invalid directive value\nDirective: *%s*\nValue: *%s*\n", directiveName, directiveValue))
}

func addInvalidDirectiveNameWarning(section, directiveName string) {
	addWarning(section, fmt.Sprintf("Invalid directive detected\nDirective: *%s*\n", directiveName))
}

func addWarning(section, warning string) {
	currentSection := sectionMap[section]
	currentSection.Warnings = append(currentSection.Warnings, warning)
	sectionMap[section] = currentSection
}

// File things
func readLinesFromFile(filePath string) []string {
	var lines []string
	file, err := os.Open(filePath)
	if err != nil {
		fmt.Printf("Error reading file %s. %s", filePath, err.Error())
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		lines = append(lines, line)
	}

	if err := scanner.Err(); err != nil {
		fmt.Printf("Error reading file %s. %s", filePath, err.Error())
	}
	return lines
}

// Parser things
func parseLine(line string) (directive, content string) {
	splitResult := strings.SplitN(line, "=", 2)

	// Check if the split result contains exactly two parts
	if len(splitResult) != 2 {
		directive = line
		content = ""
		return
	}
	directive = splitResult[0]
	content = splitResult[1]
	return
}

func parseTimeSpan(line string) (begin, end string, err bool) {
	timeParts := strings.Split(line, " ")
	if len(timeParts) != 2 {
		err = true
		begin = line
		end = ""
		return
	}

	begin = timeParts[0]
	end = timeParts[1]
	return
}

func parseBookmark(line string) (name, url string, err error) {
	bookmarkData := strings.Split(line, "^")
	if len(bookmarkData) != 2 {
		err = fmt.Errorf("\tFound\n\t*{%s}*\n\tIt has to be *{Name^URL}\n", line)
		name = line
		url = ""
		return
	}

	name = bookmarkData[0]
	url = bookmarkData[1]
	return
}

func parseTime(timeStr string) time.Time {
	parsedTime, _ := time.Parse("2006-01-02T15:04:05", timeStr)
	return parsedTime
}

// Line things
func getLineSplittedByPipe(str string) []string {
	return strings.Split(strings.Trim(str, "|"), "|")
}

func doesLineExists(query string, lines []string) bool {
	for _, line := range lines {
		if line == query {
			return true
		}
	}
	return false
}

// Functions to validate things used on multiple places
func isTimeValid(timeStr string) bool {
	_, err := time.Parse("2006-01-02T15:04:05", timeStr)
	if err != nil {
		return false
	}
	return true
}

func areTimesValid(section string, times []TimeSpan) bool {
	areValid := true
	for _, timeSpan := range times {
		isBeginTimeValid := isTimeValid(timeSpan.Begin)
		isEndTimeValid := isTimeValid(timeSpan.End)
		if !isBeginTimeValid || !isEndTimeValid {
			warning := fmt.Sprintf("Bad time range in %s section\nBegin: %s\nEnd: %s\n", section, timeSpan.Begin, timeSpan.End)
			if !isBeginTimeValid {
				warning += fmt.Sprintf("Bad begin time\n")
			}
			if !isEndTimeValid {
				warning += fmt.Sprintf("Bad end time\n")
			}
			addWarning(section, warning)
			areValid = false
		}
		beginTime := parseTime(timeSpan.Begin)
		endTime := parseTime(timeSpan.End)
		if endTime.Equal(beginTime) || endTime.Before(beginTime) {
			warning := fmt.Sprintf("Bad time range in %s section\nEnd is equal or before Begin\nBegin: %s\nEnd: %s\n", section, timeSpan.Begin, timeSpan.End)
			addWarning(section, warning)
			areValid = false
		}
	}
	return areValid
}

func isUrlValid(url string) bool {
	matchString, err := regexp.MatchString("(^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?)", url)
	if err != nil {
		return false
	}
	return matchString
}

// Global Config validations
func isTimezoneValid(timezone string) bool {
	if timezone == "" {
		addEmptyDirectiveWarning("Global", "TimeZone")
		return false
	}
	isValid := doesLineExists(timezone, availableTimezones)
	if !isValid {
		addInvalidDirectiveValueWarning("Global", "TimeZone", timezone)
	}
	return isValid
}
func isConfigExpirationTimeValid(configExpirationTime string) bool {
	if configExpirationTime == "" {
		addEmptyDirectiveWarning("Global", "ConfigExpirationTime")
		return false
	}
	isValid := configExpirationTime == "never" || isTimeValid(configExpirationTime)
	if !isValid {
		addInvalidDirectiveValueWarning("Global", "ConfigExpirationTime", configExpirationTime)
	}
	return isValid
}

func areAvailableKeyboardLayoutsValid(availableKeyboardLayouts string) bool {
	areValid := true
	layouts := getLineSplittedByPipe(availableKeyboardLayouts)
	if availableKeyboardLayouts == "" || len(layouts) == 0 || (len(layouts) == 1 && layouts[0] == "") {
		addEmptyDirectiveWarning("Global", "AvailableKeyboardLayouts")
		return false
	}
	for _, layout := range layouts {
		if !doesLineExists(layout, availableLayouts) {
			addWarning("Global", "Invalid keyboard layout ")
			areValid = false
		}
	}
	return areValid
}

func isDefaultKeyboardLayoutValid(defaultKeyboardLayout string) bool {
	if defaultKeyboardLayout == "" {
		addEmptyDirectiveWarning("Global", "DefaultKeyboardLayout")
		return false
	}
	isValid := doesLineExists(defaultKeyboardLayout, availableLayouts)
	if !isValid {
		addInvalidDirectiveValueWarning("Global", "DefaultKeyboardLayout", defaultKeyboardLayout)
	}
	return isValid
}

func isEventConfigValid(eventConfig string) bool {
	if eventConfig == "" {
		addEmptyDirectiveWarning("Global", "EventConfig")
		return false
	}
	if eventConfig == "true" && len(sectionMap["Event"].Warnings) != 0 {
		addWarning("Global", "EventConfig is set to true, but either the Event or Event-Times sections are invalid\n")
		return false
	}
	isValid := eventConfig == "false" || (eventConfig == "true" && len(sectionMap["Event"].Warnings) == 0)
	if !isValid {
		addInvalidDirectiveValueWarning("Global", "EventConfig", eventConfig)
	}
	return isValid
}
func isContestConfigValid(contestConfig string) bool {
	if contestConfig == "" {
		addEmptyDirectiveWarning("Global", "ContestConfig")
		return false
	}
	if contestConfig == "true" && len(sectionMap["Contest"].Warnings) != 0 {
		addWarning("Global", "ContestConfig is set to true, but either the Contest or Contest-Times sections are invalid\n")
		return false
	}
	isValid := contestConfig == "false" || (contestConfig == "true" && len(sectionMap["Contest"].Warnings) == 0)
	if !isValid {
		addInvalidDirectiveValueWarning("Global", "ContestConfig", contestConfig)
	}
	return isValid
}

//Specific modes validations
func areAllowedWebsitesValid(section, allowedWebsitesStr string) bool {
	if allowedWebsitesStr == "" {
		addEmptyDirectiveWarning(section, "AllowedWebsites")
		return false
	}
	if allowedWebsitesStr=="all" {
		return true
	}
	areValid := true
	allowedWebsites := getLineSplittedByPipe(allowedWebsitesStr)
	for _, url := range allowedWebsites {
		if !isUrlValid(url) {
			addInvalidDirectiveValueWarning(section, "AllowedWebsites", url)
			areValid = false
		}
	}
	return areValid
}
func isAllowUsbStorageValid(section, allowUsbStorage string) bool {
	if allowUsbStorage == "" {
		addEmptyDirectiveWarning(section, "AllowUsbStorage")
		return false
	}
	isValid := allowUsbStorage == "true" || allowUsbStorage == "false"
	if !isValid {
		addInvalidDirectiveValueWarning(section, "AllowUsbStorage", allowUsbStorage)
	}
	return isValid
}

func isAvailableSoftwareValid(section, softwareStr string) bool {
	if softwareStr == "" {
		addEmptyDirectiveWarning(section, "AvailableSoftware")
		return false
	}
	isValid := true
	softwareList := getLineSplittedByPipe(softwareStr)
	for _, software := range softwareList {
		if !doesLineExists(software, availableSoftware) {
			addInvalidDirectiveValueWarning(section, "AvailableSoftware", software)
			isValid = false
		}
	}
	return isValid
}
func areBookmarksValid(section, bookmarksStr string) bool {
	if bookmarksStr == "" {
		addEmptyDirectiveWarning(section, "Bookmarks")
		return false
	}
	areValid := true
	bookmarks := getLineSplittedByPipe(bookmarksStr)
	for _, bookmarkStr := range bookmarks {
		// Is there a need to check if the name of a bookmark is valid?
		_, bookmarkUrl, err := parseBookmark(strings.TrimRight(strings.TrimLeft(bookmarkStr, "{"), "}"))
		if err != nil {
			addWarning(section, fmt.Sprintf("Error parsing bookmark:\n%s", err.Error()))
			areValid = false
			continue
		}
		if !isUrlValid(bookmarkUrl) {
			addInvalidDirectiveValueWarning(section, "Bookmarks", bookmarkUrl)
		}
	}
	return areValid
}
func isWallpaperValid(section, wallpaperUrl string) bool {
	if wallpaperUrl == "" {
		addEmptyDirectiveWarning(section, "Wallpaper")
		return false
	}
	return true
}
func isWallpaperSha256Valid(section, wallpaperSha256 string) bool {
	// If the default walpaper is set, no need for a sha string
	if sectionMap[section].SectionDirectives["Wallpaper"] == "default" {
		return true
	}
	if wallpaperSha256 == "" {
		addEmptyDirectiveWarning(section, "WallpaperSha256")
		return false
	}
	return true
}

// Function to validate the global directives section
func validateGlobalDirectives(directives map[string]string) bool {
	// availableGlobalDirectives as map to be able to quickly check if a value is in the map or not
	availableGlobalDirectives := map[string]struct{}{
		"AvailableKeyboardLayouts": {},
		"ConfigExpirationTime":     {},
		"ContestConfig":            {},
		"DefaultKeyboardLayout":    {},
		"EventConfig":              {},
		"TimeZone":                 {},
	}
	for directiveName, _ := range directives {
		_, isDirectivePresent := availableGlobalDirectives[directiveName]
		if !isDirectivePresent {
			addInvalidDirectiveNameWarning("Global", directiveName)
		}
	}
	areAllDirectivesValid := true
	if !isTimezoneValid(directives["TimeZone"]) {
		areAllDirectivesValid = false
	}
	if !isConfigExpirationTimeValid(directives["ConfigExpirationTime"]) {
		areAllDirectivesValid = false
	}
	if !areAvailableKeyboardLayoutsValid(directives["AvailableKeyboardLayouts"]) {
		areAllDirectivesValid = false
	}
	if !isDefaultKeyboardLayoutValid(directives["DefaultKeyboardLayout"]) {
		areAllDirectivesValid = false
	}
	if !isEventConfigValid(directives["EventConfig"]) {
		areAllDirectivesValid = false
	}
	if !isContestConfigValid(directives["ContestConfig"]) {
		areAllDirectivesValid = false
	}
	return areAllDirectivesValid
}

// Function to validate the Always/Event/Contest directives sections
func validateModeDirectives(section string, directives map[string]string) bool {
	// availableGlobalDirectives as map to be able to quickly check if a value is in the map or not
	availableModeDirectives := map[string]struct{}{
		"AllowedWebsites":   {},
		"AllowUsbStorage":   {},
		"AvailableSoftware": {},
		"Bookmarks":         {},
		"Wallpaper":         {},
		"WallpaperSha256":   {},
	}
	for directiveName, _ := range directives {
		_, isDirectivePresent := availableModeDirectives[directiveName]
		if !isDirectivePresent {
			addWarning(section, fmt.Sprintf("Invalid directive detected, it will be ignored by the system\nDirective: *%s*\n", directiveName))
		}
	}
	areAllDirectivesValid := true
	if !areAllowedWebsitesValid(section, directives["AllowedWebsites"]) {
		areAllDirectivesValid = false
	}
	if !isAllowUsbStorageValid(section, directives["AllowUsbStorage"]) {
		areAllDirectivesValid = false
	}
	if !isAvailableSoftwareValid(section, directives["AvailableSoftware"]) {
		areAllDirectivesValid = false
	}
	if !areBookmarksValid(section, directives["Bookmarks"]) {
		areAllDirectivesValid = false
	}
	if !isWallpaperValid(section, directives["Wallpaper"]) {
		areAllDirectivesValid = false
	}
	if !isWallpaperSha256Valid(section, directives["WallpaperSha256"]) {
		areAllDirectivesValid = false
	}
	return areAllDirectivesValid
}

func main() {
	availableLayouts = readLinesFromFile("layouts.txt")
	availableTimezones = readLinesFromFile("timezones.txt")
	availableSoftware = readLinesFromFile("software.txt")

	// Read the file
	file, err := os.Open("cpci.hdf")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

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
			if err == true {
				addWarning(sectionName, fmt.Sprintf("Error parsing time span:%s", line))
				return
			}
			currentSectionValue.Times = append(currentSectionValue.Times, TimeSpan{Begin: begin, End: end})
			// Update the map with the modified section value
			sectionMap[sectionName] = currentSectionValue
		} else if currentSection != "" {
			// Retrieve the current section value from the map
			currentSectionValue := sectionMap[currentSection]
			// Modify the Content field of the struct
			directive, content := parseLine(line)
			if currentSectionValue.SectionDirectives == nil {
				currentSectionValue.SectionDirectives = make(map[string]string)
			}
			currentSectionValue.SectionDirectives[directive] = content
			// Update the map with the modified section value
			sectionMap[currentSection] = currentSectionValue
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading file:", err)
		return
	}

	// Validate sections and print validation results
	// Validate Event and Contest sections before Global
	// in case EventConfig or ContestConfig are set
	// to throw error if not configured correctly

	// Validate Event section
	currentSection = "Event"
	if validateModeDirectives(currentSection, sectionMap[currentSection].SectionDirectives) && areTimesValid(currentSection, sectionMap[currentSection].Times) {
		fmt.Printf("%s validation: Passed\n", currentSection)
	} else {
		fmt.Printf("%s validation: Failed\n", currentSection)
		printWarnings(sectionMap[currentSection].Warnings)
	}
	// Validate Contest section
	currentSection = "Contest"
	if validateModeDirectives(currentSection, sectionMap[currentSection].SectionDirectives) && areTimesValid(currentSection, sectionMap[currentSection].Times) {
		fmt.Printf("%s validation: Passed\n", currentSection)
	} else {
		fmt.Printf("%s validation: Failed\n", currentSection)
		printWarnings(sectionMap[currentSection].Warnings)
	}
	// Validate Always section
	currentSection = "Always"
	if validateModeDirectives(currentSection, sectionMap[currentSection].SectionDirectives) {
		fmt.Printf("%s validation: Passed\n", currentSection)
	} else {
		fmt.Printf("%s validation: Failed\n", currentSection)
		printWarnings(sectionMap[currentSection].Warnings)
	}
	// Validate Global section
	currentSection = "Global"
	if validateGlobalDirectives(sectionMap[currentSection].SectionDirectives) {
		fmt.Printf("%s validation: Passed\n", currentSection)
	} else {
		fmt.Printf("%s validation: Failed\n", currentSection)
		printWarnings(sectionMap[currentSection].Warnings)
	}
}

func printWarnings(warnings []string) {
	for _, warning := range warnings {
		fmt.Printf("*****WARNING*****\n")
		fmt.Printf("%s", warning)
	}
}
