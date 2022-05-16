#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


#include "hangman.h"

char solution[7] = "HANGMAN";
char current[8] = "_______";
char misses[7] = "";
int missCount = 0;

char gameLine[108] = "   |-----|\n   |     |\n   |     |\n         |\n         |\n         |\n         |\n         |\n ---------\n";

bool check_game(char *word) {
	for (int x = 0; x < sizeof(current); x++) {
		if (current[x] == '\0') break;
		if (current[x] == '_') return false;
	}
	return true;
}

void print_game() {
	printf("%s", gameLine);
	printf("Word: %s\n", current);
	printf("Misses: %s\n", misses);
}

char user_input() {
	printf("Enter next character (A-Z), or 0 (zero) to exit: ");
	char input[1];
	scanf("%s", input);
	
	return input[0];
}

int main() {
	
	printf("Welcome to Hangman!\nVersion 1.0\nImplemented by Andrew Kim\n\n");

	while (!check_game(current)) {
		print_game();
		char input = user_input();
		
		printf("\n");
		if (input == '0') {
			printf("Exiting game...\n");
			return -2;
		}
		if (input < 'A' || input > 'Z') {
			printf("Invalid input\n");
			continue;
		}
		
		for (int x = 0; x < sizeof(current); x++) {
			if (current[x] == input) {
				printf("Already used character\n");
				break;
			}
		}
		
		for (int x = 0; x < sizeof(misses); x++) {
			if (misses[x] == input) {
				printf("Already used character\n");
				break;
			}
		}
		
		bool missed = true;
		
		for (int x = 0; x < sizeof(solution); x++) {
			if (solution[x] == input) {
				current[x] = input;
				missed = false;
			}
		}
		
		if (missed) {
			misses[missCount] = input;
			missCount++;
			if (missCount == 1) {
				gameLine[36] = 'O';
			} else if (missCount == 2) {
				gameLine[47] = '|';
				gameLine[58] = '|';
			} else if (missCount == 3) {
				gameLine[46] = '\\';
			} else if (missCount == 4) {
				gameLine[48] = '/';
			} else if (missCount == 5) {
				gameLine[68] = '/';
			} else if (missCount == 6) {
				gameLine[70] = '\\';
				print_game();
				printf("You lose - out of moves\n");
				return -1;
			}
		}
	}
	print_game();
	printf("Congratulations - you win!\n");

	return 0;
}
