{společné deklarace pro bar}

unit bar_tog;
interface

const max_folder_length=65000;
      max_num_open_archives=10;
      max_folders_in_archive=10000;
      max_tree_depth=256;

type plongintarray=^tlongintarray;
     tlongintarray=array[1..max_folders_in_archive]of longint;

     pwordarray=^twordarray;
     twordarray=array[1..1000]of word;

     pbytearray=^tbytearray;
     tbytearray=array[1..max_folder_length]of byte;

implementation

end.
