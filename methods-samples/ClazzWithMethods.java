package org.mycomoany

import java.util.Date;
import java.io.BufferedReader;
import java.io.CharArrayWriter;

/**
* this is my javadoc
*/

public class ClazzWithMethods {
	
	private String name;
	private String surname;
	
	public String getName() {
		return name;
	}
	
	public String setSurname(String surname) {
		this.surname = surname;
	}
	
	protected String pseudo() {
		String pseudo = name + surname;
		return pseudo
	}
	
	private String safePseudo() {
		if(name != null && surname != null) {
			return name + surname;
		} else if(name != null) {
			return name;
		} else if(surname != null) {
			return surname
		} else return "no-pseudo";
	}
}      
