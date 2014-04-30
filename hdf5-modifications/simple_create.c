#include "hdf5.h"
#define FILE "file.h5"

int main() {

   hid_t       file_id;   /* file identifier */
   herr_t      status;

   printf("hi\n");
   /* Create a new file using default properties. */
   file_id = 0;
   //file_id = H5Fcreate(FILE, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
   printf("bye\n");

   /* Terminate access to the file. */
   status = H5Fclose(file_id); 
   printf("buh-bye\n");
}
