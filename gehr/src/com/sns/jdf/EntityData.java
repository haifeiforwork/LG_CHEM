/**
  * EntityData.java
  *
  **/

// PACKAGE
package com.sns.jdf;

import java.lang.reflect.*;

/**
 * @(#) EntityData.java
 * dbEntity의 추상class - toString() method impliment
 */
 
public abstract class EntityData implements java.io.Serializable
{
	public EntityData() {
		super();
	}

	/**
	 * dbentity의 필드들을 출력.
	 * @return String : { field_name = field_value, ... }의 형식으로 출력
	 */
	public String toString() {
		StringBuffer buf = new StringBuffer();
			
		Class c = this.getClass();
		String fullname = c.getName();
		String name = null;
		int index = fullname.lastIndexOf('.');
		if ( index == -1 ) name = fullname;
		else name = fullname.substring(index+1);
		buf.append(name + ":{");
			
		Field[] fields = c.getFields();
		for (int i=0 ; i<fields.length; i++) {
			try {
				if ( i != 0 ) buf.append(',');
				buf.append(fields[i].getName() + '=');
				Object f = fields[i].get(this);
				Class fc = fields[i].getType();
				if ( fc.isArray() ) {
					buf.append('[');
					int length = Array.getLength(f);
					for(int j=0; j<length ;j++){
						if ( j != 0 ) buf.append(',');
						Object element = Array.get(f, j);
						buf.append(element.toString());
					}
					buf.append(']');
				}
				else 	
					buf.append(f.toString());
			}
			catch(Exception e) {}
		}
		buf.append('}');
		return buf.toString();
	}
}

