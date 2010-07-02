package controllers;
import java.util.Comparator;
import java.util.Arrays;
import java.io.File;

/**
 * Currently, this class provides a sorted directory listing,
 * but it may be useful to have a utility class that returns
 * an ArrayList of Files, that can easily be sorted in Duby,
 * and provides appropriate methods from Ruby's Dir Object:
 **/
class Dir {
    // return IgnoreCase sorted Files list, or null when not a directory
    public static File[] listFilesSorted(File directory) {
        File[] files = directory.listFiles();
        if (files == null) {
            return null;
        } else {
            Arrays.sort(files, new Comparator<File>() {
                public int compare(File f1, File f2)
                {
                    return f1.getName().compareToIgnoreCase(f2.getName());
                } });
            return files;
        }
    }
}
