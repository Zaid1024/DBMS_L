#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Student {
  int SID;
  char NAME[50];
  char BRANCH[50];
  int SEMESTER;
  char ADDRESS[100];
};

void insertStudent() {
  struct Student student;
  FILE *file = fopen("students.dat", "ab");

  if (file == NULL) {
    printf("Error opening file for writing!\n");
    return;
  }

  printf("Enter Student ID: ");
  scanf("%d", &student.SID);
  printf("Enter Student Name: ");
  scanf("%s", student.NAME);
  printf("Enter Student Branch: ");
  scanf("%s", student.BRANCH);
  printf("Enter Student Semester: ");
  scanf("%d", &student.SEMESTER);
  printf("Enter Student Address: ");
  scanf("%s", student.ADDRESS);

  fwrite(&student, sizeof(struct Student), 1, file);
  fclose(file);

  printf("Student added successfully!\n");
}

void modifyStudentAddress(int sid) {
  struct Student student;
  FILE *file = fopen("students.dat", "rb+");
  int found = 0;

  if (file == NULL) {
    printf("Error opening file for modification!\n");
    return;
  }

  while (fread(&student, sizeof(struct Student), 1, file)) {
    if (student.SID == sid) {
      printf("Enter new address for student %d: ", sid);
      scanf("%s", student.ADDRESS);
      fseek(file, -sizeof(struct Student), SEEK_CUR);
      fwrite(&student, sizeof(struct Student), 1, file);
      found = 1;
      break;
    }
  }

  fclose(file);

  if (found) {
    printf("Address modified successfully!\n");
  } else {
    printf("Student with SID %d not found!\n", sid);
  }
}

void deleteStudent(int sid) {
  struct Student student;
  FILE *file = fopen("students.dat", "rb");
  FILE *tempFile = fopen("temp.dat", "wb");
  int found = 0;

  if (file == NULL || tempFile == NULL) {
    printf("Error opening files for deletion!\n");
    return;
  }

  while (fread(&student, sizeof(struct Student), 1, file)) {
    if (student.SID == sid) {
      found = 1;
    } else {
      fwrite(&student, sizeof(struct Student), 1, tempFile);
    }
  }

  fclose(file);
  fclose(tempFile);

  if (found) {
    remove("students.dat");
    rename("temp.dat", "students.dat");
    printf("Student with SID %d deleted successfully!\n", sid);
  } else {
    remove("temp.dat");
    printf("Student with SID %d not found!\n", sid);
  }
}

void listAllStudents() {
  struct Student student;
  FILE *file = fopen("students.dat", "rb");

  if (file == NULL) {
    printf("Error opening file for listing students!\n");
    return;
  }

  printf("List of all students:\n");
  while (fread(&student, sizeof(struct Student), 1, file)) {
    printf("SID: %d, Name: %s, Branch: %s, Semester: %d, Address: %s\n",
           student.SID, student.NAME, student.BRANCH, student.SEMESTER,
           student.ADDRESS);
  }

  fclose(file);
}

void listStudentsByBranch(const char *branch) {
  struct Student student;
  FILE *file = fopen("students.dat", "rb");

  if (file == NULL) {
    printf("Error opening file for listing students by branch!\n");
    return;
  }

  printf("List of students in branch %s:\n", branch);
  while (fread(&student, sizeof(struct Student), 1, file)) {
    if (strcmp(student.BRANCH, branch) == 0) {
      printf("SID: %d, Name: %s, Branch: %s, Semester: %d, Address: %s\n",
             student.SID, student.NAME, student.BRANCH, student.SEMESTER,
             student.ADDRESS);
    }
  }

  fclose(file);
}

void listStudentsByBranchAndAddress(const char *branch, const char *address) {
  struct Student student;
  FILE *file = fopen("students.dat", "rb");

  if (file == NULL) {
    printf("Error opening file for listing students by branch and address!\n");
    return;
  }

  printf("List of students in branch %s and residing in %s:\n", branch,
         address);
  while (fread(&student, sizeof(struct Student), 1, file)) {
    if (strcmp(student.BRANCH, branch) == 0 &&
        strcmp(student.ADDRESS, address) == 0) {
      printf("SID: %d, Name: %s, Branch: %s, Semester: %d, Address: %s\n",
             student.SID, student.NAME, student.BRANCH, student.SEMESTER,
             student.ADDRESS);
    }
  }

  fclose(file);
}
int main() {
  int choice, sid;
  char branch[50], address[50];

  while (1) {
    printf("\nMenu:\n");
    printf("1. Insert a new student\n");
    printf("2. Modify student address by SID\n");
    printf("3. Delete a student by SID\n");
    printf("4. List all students\n");
    printf("5. List students by branch\n");
    printf("6. List students by branch and address\n");
    printf("7. Exit\n");
    printf("Enter your choice: ");
    scanf("%d", &choice);

    switch (choice) {
    case 1:
      insertStudent();
      break;
    case 2:
      printf("Enter Student SID for address modification: ");
      scanf("%d", &sid);
      modifyStudentAddress(sid);
      break;
    case 3:
      printf("Enter Student SID for deletion: ");
      scanf("%d", &sid);
      deleteStudent(sid);
      break;
    case 4:
      listAllStudents();
      break;
    case 5:
      printf("Enter branch name: ");
      scanf("%s", branch);
      listStudentsByBranch(branch);
      break;
    case 6:
      printf("Enter branch name: ");
      scanf("%s", branch);
      printf("Enter address: ");
      scanf("%s", address);
      listStudentsByBranchAndAddress(branch, address);

      break;
    case 7:
      exit(0);
    default:
      printf("Invalid choice! Please try again.\n");
    }
  }

  return 0;
}