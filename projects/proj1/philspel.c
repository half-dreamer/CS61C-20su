/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  // -- TODO --
  unsigned int Hash = 0;
  char *string = (char *)s;
  for (int i=0 ;i < strlen(string) ;i++) {
    Hash = Hash * 31 + (int)*(string + i);
  }
  Hash = Hash % dictionary->size - 1;
  return Hash;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  // -- TODO --
  return strcmp(string1,string2) == 0;
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  // -- TODO --
  FILE* fp;
  int size = 200;
  int maxWordSize = 500;
  char* word = (char *)malloc((size + 1) * sizeof(char));
  if ((fp = fopen(dictName,"r")) == NULL ) {
    fprintf(stderr,"can't open the file!");
    exit(1);
  }

  while (fgets(word,maxWordSize,fp) != NULL) {
    // note: this string have newline "\n" at the second to the last 
    // so we get rid of newline
    // actually,it seems a better way to allocate a new memory to store this word to insert in dictionary
    // such as using memcpy function
    *(word + strlen(word) -2) = '\0';
    if (findData(dictionary,word) == NULL) {
      insertData(dictionary,word,word);
    } 
  }

  fclose(fp);
  free(word);
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  // -- TODO --
  int readInCharSize = 500;
  int curIndex = 0;
  char readInChar;
  char* case1 = (char *)malloc((readInCharSize + 1) * sizeof(char));
  char* case2 = (char *)malloc((readInCharSize + 1) * sizeof(char));
  char* case3 = (char *)malloc((readInCharSize + 1) * sizeof(char));

  while ((readInChar = getchar()) != EOF ) {
    /* this branch condition is equivalent to fgetc(stdin)*/
    if (isalpha(readInChar)) {
        case1[curIndex] = readInChar;
        *(case2 + curIndex) = readInChar;
        *(case3 + curIndex) = tolower(readInChar);
      if (curIndex != 0) {
        *(case2 + curIndex) = tolower(readInChar);
      }
      curIndex ++;
    } else {
    // not alpha case
    if (curIndex == 0) {
      // deal with continuegous nonalphabeta char. we don't write null(i.e. nothing) to stdout
      // but we still need to output it
      // to be more compressed , we can use the ? : expression ,more elegant
      fprintf(stdout,"%c",readInChar);
      continue;
    } else {
      //append every inputWord with a '\0'
      *(case1 + curIndex) = *(case2 + curIndex) = *(case3 + curIndex) = '\0';
      curIndex = 0;

      if (findData(dictionary,case1) || findData(dictionary,case2) || findData(dictionary,case3)) {
        fprintf(stdout,"%s%c",case1,readInChar);
        continue;
      } else {
        fprintf(stdout,"%s [sic]%c",case1,readInChar);
      }
    }
    }
    // to empty the string pointer , we can use the memset funciton 
  }
  // end is EOF case
  *(case1 + curIndex) = *(case2 + curIndex) = *(case3 + curIndex) = '\0';
  if (findData(dictionary,case1) || findData(dictionary,case2) || findData(dictionary,case3)) {
        fprintf(stdout,"%s",case1);
      } else {
        fprintf(stdout,"%s [sic]",case1);
      }
    free(case1);
    free(case2);
    free(case3);
}
