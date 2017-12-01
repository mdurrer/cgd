/*
 * Relaunch64 - A Java cross-development IDE for C64 machine language coding.
 * Copyright (C) 2001-2015 by Daniel Lüdecke (http://www.danielluedecke.de)
 * 
 * Homepage: http://www.popelganda.de
 * 
 * 
 * This program is free software; you can redistribute it and/or modify it under the terms of the
 * GNU General Public License as published by the Free Software Foundation; either version 3 of 
 * the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program;
 * if not, see <http://www.gnu.org/licenses/>.
 * 
 * 
 * Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU
 * General Public License, wie von der Free Software Foundation veröffentlicht, weitergeben
 * und/oder modifizieren, entweder gemäß Version 3 der Lizenz oder (wenn Sie möchten)
 * jeder späteren Version.
 * 
 * Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen sein 
 * wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder 
 * der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK. Details finden Sie in der 
 * GNU General Public License.
 * 
 * Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm 
 * erhalten haben. Falls nicht, siehe <http://www.gnu.org/licenses/>.
 */
package de.relaunch64.popelganda.Editor;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author Daniel Lüdecke
 */
public class SectionExtractor {

    public static LinkedHashMap getSections(String source, String assemblerComment) {
        // prepare return values
        LinkedHashMap<String, Integer> sectionValues = new LinkedHashMap<>();
        String line;
        // go if not null
        if (source != null) {
            // create buffered reader, needed for line number reader
            BufferedReader br = new BufferedReader(new StringReader(source));
            LineNumberReader lineReader = new LineNumberReader(br);
            // Section-pattern is a comment line with "@<section description>@"
            Pattern p = Pattern.compile("^\\s*" + assemblerComment + ".*@(.*?)@.*");
            // read line by line
            try {
                while ((line = lineReader.readLine()) != null) {
                    Matcher m = p.matcher(line);
                    if (!m.matches()) {
                        continue;
                    }
                    sectionValues.put(m.group(1), lineReader.getLineNumber());
                }
            } catch (IOException ex) {
            }
        }
        return sectionValues;
    }

    public static ArrayList getSectionLineNumbers(String source, String assemblerComment) {
        return new ArrayList<>(getSections(source, assemblerComment).values());
    }

    public static ArrayList getSectionNames(String source, String assemblerComment) {
        return new ArrayList<>(getSections(source, assemblerComment).keySet());
    }

}
