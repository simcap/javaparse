package org.mycompany

import java.util.Date;

// confusing comments
//class
/* class */
/** class */

public interface SimpleInterface {
	

	@Perform
	public abstract void doStuff(); 


	public void doOtherStuff(); 

	@Perform
	@Annotation
	void doMoreStuff(); 
}      
