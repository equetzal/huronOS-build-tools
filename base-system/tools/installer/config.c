#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 100
#define MAX_CONFIGS 10

struct Config {
    char key[MAX_LINE_LENGTH];
    char value[MAX_LINE_LENGTH];
};

int main(int argc, char *argv[]) {

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        perror("The file doesn't exist");
        return 1;
    }

    struct Config config[MAX_CONFIGS];
    int configCount = 0;
    
    char line[MAX_LINE_LENGTH];
    while (fgets(line, sizeof(line), file)) {
         if (line[0] == '#') {
            continue;
        }

        char *key = strtok(line, "=");
        char *value = strtok(NULL, "\n");

        if (key) {
            strcpy(config[configCount].key, key);
            if (value) {
                strcpy(config[configCount].value, value);
            } else {
                config[configCount].value[0] = '\0';
            }
            configCount++;
        }
    }

    fclose(file);


    for (int i = 0; i < configCount; i++) {
        printf("%s\n", config[i].value);
    }

    return 0;
}

