package com.sns.jdf.servlet;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;

import hris.common.AppLineData;

public class Box extends java.util.Hashtable {

	public Box() {
		// TODO Auto-generated constructor stub
	}

	protected String name = null;
	/**
	 *
	 */
	public Box(String name) {
		super();
		this.name = name;
	}
    /**
     *
     */
    public Object clone() {

        Box newbox = new Box(name);

        Hashtable src = (Hashtable)this;
        Hashtable target = (Hashtable)newbox;

        Enumeration e = src.keys();
        while(e.hasMoreElements()) {
            String key = (String) e.nextElement();
            Object value =  src.get(key);
            target.put(key,value);
        }
        return newbox;
    }

    public <T> T createEntity(Class<T> klass)  {
    	try{
    		T o = klass.newInstance();
			copyToEntity(o);
			return o;
		} catch(Exception e) {
		}

    	return null;
	}

	public <T> T createEntity(Class<T> klass, String prefix)  {
		try{
			T o = klass.newInstance();
			copyToEntity(o, prefix);
			return o;
		} catch(Exception e) {
		}

		return null;
	}

    /**
     *
     * @param entity java.lang.Object
     */
    public void copyToEntity(Object entity) {
        if ( entity == null )
            throw new NullPointerException("trying to copy from box to null entity class");

        Class c = entity.getClass();
        java.lang.reflect.Field[] field = c.getFields();
        for (int i=0 ; i<field.length; i++) {
            try {
                String fieldtype = field[i].getType().getName();
                String fieldname = field[i].getName();
                if ( containsKey( fieldname ) ) {
                    if ( fieldtype.equals("java.lang.String")) {
                        field[i].set(entity, getString(fieldname));
                    }
                    else if ( fieldtype.equals("int")) {
                        field[i].setInt(entity, getInt(fieldname));
                    }
                    else if ( fieldtype.equals("double")) {
                        field[i].setDouble(entity, getDouble(fieldname));
                    }
                    else if ( fieldtype.equals("long")) {
                        field[i].setLong(entity, getLong(fieldname));
                    }
                    else if ( fieldtype.equals("float")) {
                        field[i].set(entity, new Float(getDouble(fieldname)));
                    }
                    else if ( fieldtype.equals("boolean")) {
                        field[i].setBoolean(entity, getBoolean(fieldname));
                    }
                }
            }
            catch(Exception e){
                //Debug.warn.println(this, e.getMessage());
            }
        }
    }


	public void copyToEntity(Object entity, String prefix) {
		if ( entity == null )
			throw new NullPointerException("trying to copy from box to null entity class");

		Class c = entity.getClass();
		java.lang.reflect.Field[] field = c.getFields();
		for (int i=0 ; i<field.length; i++) {
			try {
				String fieldtype = field[i].getType().getName();
				String fieldname = StringUtils.defaultIfEmpty(prefix, "") + field[i].getName();
				if ( containsKey( fieldname ) ) {
					if ( fieldtype.equals("java.lang.String")) {
						field[i].set(entity, getString(fieldname));
					}
					else if ( fieldtype.equals("int")) {
						field[i].setInt(entity, getInt(fieldname));
					}
					else if ( fieldtype.equals("double")) {
						field[i].setDouble(entity, getDouble(fieldname));
					}
					else if ( fieldtype.equals("long")) {
						field[i].setLong(entity, getLong(fieldname));
					}
					else if ( fieldtype.equals("float")) {
						field[i].set(entity, new Float(getDouble(fieldname)));
					}
					else if ( fieldtype.equals("boolean")) {
						field[i].setBoolean(entity, getBoolean(fieldname));
					}
				}
			}
			catch(Exception e){
				//Debug.warn.println(this, e.getMessage());
			}
		}
	}

    /**
     *
     * @param entity java.lang.Object
     */
    public void copyToEntity(Object entity, int index) {
        if ( entity == null )
            throw new NullPointerException("trying to copy from box to null entity class");

        Class c = entity.getClass();
        java.lang.reflect.Field[] field = c.getFields();
        for (int i=0 ; i<field.length; i++) {
            try {
                String fieldtype = field[i].getType().getName();
                String fieldname = field[i].getName() + Integer.toString(index);
                if ( containsKey( fieldname ) ) {

                    if ( fieldtype.equals("java.lang.String")) {
                        field[i].set(entity, getString(fieldname));
                    }
                    else if ( fieldtype.equals("int")) {
                        field[i].setInt(entity, getInt(fieldname));
                    }
                    else if ( fieldtype.equals("double")) {
                        field[i].setDouble(entity, getDouble(fieldname));
                    }
                    else if ( fieldtype.equals("long")) {
                        field[i].setLong(entity, getLong(fieldname));
                    }
                    else if ( fieldtype.equals("float")) {
                        field[i].set(entity, new Float(getDouble(fieldname)));
                    }
                    else if ( fieldtype.equals("boolean")) {
                        field[i].setBoolean(entity, getBoolean(fieldname));
                    }
                }
            }
            catch(Exception e){
                //Debug.warn.println(this, e.getMessage());
            }
        }
    }
	/**
	 * @return java.lang.String
	 * @param key java.lang.String
	 */
	public String get(String key) {
		return getString(key);
	}

	public String get(String key, String defaultString) {
		return StringUtils.defaultIfEmpty(getString(key), defaultString);
	}


	public Object getObject(String key) {
		return super.get(key);
	}

	/**
	 * @return java.lang.String
	 * @param key java.lang.String
	 */
	public boolean getBoolean(String key) {
		String value = getString(key);
		boolean isTrue = false;
		try {
			isTrue = (new Boolean(value)).booleanValue();
		}
		catch(Exception e){}
		return isTrue;
	}
	/**
	 * @return java.lang.String
	 * @param key java.lang.String
	 */
	public double getDouble(String key) {
		String value = removeComma(getString(key));
		if ( value.equals("") ) return 0;
		double num = 0;
		try {
			num = Double.valueOf(value).doubleValue();
		}
		catch(Exception e) {
			num = 0;
		}
		return num;
	}

	/**
	 * @return java.lang.String
	 * @param key java.lang.String
	 */
	public double getFloat(String key) {
		return (float)getDouble(key);
	}
	/**
	 * @return java.lang.String
	 * @param key java.lang.String
	 */
	public int getInt(String key) {
		double value = getDouble(key);
		return (int)value;
	}
	/**
	 * @return java.lang.String
	 * @param key java.lang.String
	 */
	public long getLong(String key) {
		String value = removeComma(getString(key));
		if ( value.equals("") ) return 0L;

		long lvalue = 0L;
		try {
			lvalue = Long.valueOf(value).longValue();
		}
		catch(Exception e) {
			lvalue = 0L;
		}

		return lvalue;
	}
	/**
	 * @return java.lang.String
	 * @param key java.lang.String
	 */
	public String getString(String key) {
		String value = null;
		try {
			Object o = (Object)super.get(key);
			Class c = o.getClass();
			if ( o == null ) value = "";
			else if( c.isArray() ) {
				int length = Array.getLength(o);
				if ( length == 0 ) value = "";
				else {
					Object item = Array.get(o, 0);
					if ( item == null ) value = "";
					else value = item.toString();
				}
			}
			else 	value = o.toString();
		}
		catch(Exception e) {
			value = "";
		}
		return value;
	}
	/**
	 * check box 와 같이 같은 name에 대해 여러 value들이 String의 Vector로 넘겨준다.
	 * @return Vector
	 * @param key java.lang.String
	 */
	public Vector<String> getVector(String key) {
		Vector<String> vector = new Vector();
		try {
			Object o = (Object)super.get(key);
			Class c = o.getClass();
			if ( o != null ) {
				if( c.isArray() ) {
					int length = Array.getLength(o);
					if ( length != 0 ) {
						for(int i=0; i<length;i++) {
							Object tiem = Array.get(o, i);
							if (tiem == null ) vector.addElement("");
							else vector.addElement(tiem.toString());
						}
					}
				}
				else
					vector.addElement(o.toString());
			}
		}
		catch(Exception e) {}
		return vector;
	}

	public <T> Vector<T> getVector(Class<T> klass) throws GeneralException {
		return getVector(klass, null);
	}

	/**
	 * 파라머터값들을 Vector<Entity>형태로 가져온다
	 * remove 값이 true 일 경우 field 명에서 prefix 를 제거한 파라메터 값을 가져온다
	 * false 일 경우에는 field 명에 prefix 값을 추가한 파라메터 를 가져옴
	 * ex)
	 * 		klass 에 필드명 TEST_ABC
	 * 		getVector(Class<T> klass, "TEST_", true)
	 * 		request.getParameter("ABC") 랑 동일
	 *
 * 	* 		getVector(Class<T> klass, "TEST_", false)
	 * 		request.getParameter("TEST_TEST_ABC") 랑 동일
	 * @param klass
	 * @param prefix
	 * @param remove
	 * @param <T>
	 * @return
	 * @throws GeneralException
	 */
	public <T> Vector<T> getVector(Class<T> klass, String prefix, boolean remove) throws GeneralException {
		Field[] fields = klass.getFields(); //필드 가져오기

		Vector<T> resultList = new Vector<T>();

		int nMaxSize = 0;

		prefix = StringUtils.defaultString(prefix);

		for(Field field : fields) {
			try {
				String[] value = (String[]) super.get( remove ? StringUtils.remove(field.getName(), prefix) : prefix + field.getName());
				if(value != null && value.length > nMaxSize) nMaxSize = value.length;
			} catch(Exception e) {
				Logger.error(e);	//Type error
			}
		}

		try {
			for (int n = 0; n < nMaxSize; n++) {
				T o = klass.newInstance();

				for (Field field : fields) {
					try {
						String[] value = (String[]) super.get( remove ? StringUtils.remove(field.getName(), prefix) : prefix + field.getName());
						if (value == null) continue;

						if (n < value.length) {
							field.set(o, value[n]);
						}
					} catch (Exception e) {
						Logger.error(e);	//Type error
					}
				}

				resultList.add(o);
			}
		} catch(Exception e) {
			throw new GeneralException(e);
		}

		return resultList;

	}
	/**
	 * request 에서 넘어온 값을 Vector<Entity> 형태로 변환
	 * @param klass
	 * @param <T>
	 * @return
	 * @throws GeneralException
	 */
	public <T> Vector<T> getVector(Class<T> klass, String prefix) throws GeneralException {
		return getVector(klass, prefix, false );

	}

	/**
	 * @param key java.lang.String
	 * @param value java.lang.String
	 */
	public void put(String key, String value) {
		super.put(key, StringUtils.defaultString(value));
	}

	/**
	 * remove "," in string.
	 * @return java.lang.String
	 * @param s java.lang.String
	 */
	private static String removeComma(String s) {
		if ( s == null ) return null;
		if ( s.indexOf(",") != -1 ) {
			StringBuffer buf = new StringBuffer();
			for(int i=0;i<s.length();i++){
				char c = s.charAt(i);
				if ( c != ',') buf.append(c);
			}
			return buf.toString();
		}
		return s;
	}
    /**
     *
     * @return java.lang.String
     */
    public synchronized String toString() {
        int max = size() - 1;
        StringBuffer buf = new StringBuffer();
        Enumeration keys = keys();
        Enumeration objects = elements();
        buf.append("{");

        for (int i = 0; i <= max; i++) {
            String key = keys.nextElement().toString();
            String value = null;
            Object o = objects.nextElement();
            if ( o == null ) value = "";
            else {
                Class  c = o.getClass();
                if( c.isArray() ) {
                    int length = Array.getLength(o);
                    if ( length == 0 ) 	value = "";
                    else if ( length == 1 ) {
                        Object item = Array.get(o, 0);
                        if ( item == null ) value = "";
                        else value = item.toString();
                    }
                    else {
                        StringBuffer valueBuf = new StringBuffer();
                        valueBuf.append("[");
                        for ( int j=0;j<length;j++) {
                            Object item = Array.get(o, j);
                            if ( item != null ) valueBuf.append(item.toString());
                            if ( j<length-1) valueBuf.append(",");
                        }
                        valueBuf.append("]");
                        value = valueBuf.toString();
                    }
                }
                else
                    value = o.toString();
            }
            buf.append(key + "=" + value);
            if (i < max) buf.append(", ");
        }
        buf.append("}");

        return "Box["+name+"]=" + buf.toString();

    }

    /**
     * [WorkTime52] 유정우 추가
     * 
     * @return
     */
    public Map<String, Object> getHashMap() {

        Map<String, Object> map = new HashMap<String, Object>();
        for (Object key : keySet()) {
            map.put((String) key, getString((String) key));
        }
        return map;
    }

    public static void main(String[] args){

    	//AppLineData:{APPL_MANDT=5000,APPL_BUKRS=,APPL_AINF_SEQN=,APPL_BEGDA=,APPL_UPMU_FLAG=,APPL_UPMU_TYPE=,APPL_APPU_NUMB=,APPL_APPR_TYPE=,APPL_APPU_TYPE=,APPL_APPU_NAME=,APPL_APPR_SEQN=,APPL_PERNR=,APPL_ENAME=,APPL_ORGTX=,APPL_TITEL=,APPL_TITL2=,APPL_OTYPE=,APPL_OBJID=,APPL_STEXT=,APPL_APPR_DATE=,APPL_APPR_STAT=,APPL_TELNUMBER=,APPL_BIGO_TEXT=}
    	Box box = new Box("test");
    	 int rowcount=2;
    	  for( int i = 0; i < rowcount; i++ ) {
              AppLineData appLine = new AppLineData();
              Class c = appLine.getClass();
              String fullname = c.getName();
              Logger.debug("c : " + c);
          	   Field[] fields = c.getFields();
          	 Logger.debug("c fields : " + fields);
              Logger.debug("fullname : " + fullname);
              // 여러행 자료 입력(Web)
              box.copyToEntity(appLine , i);
              appLine.APPL_MANDT = "500"+i;
              //Logger.debug(appLine);

    	  }
    }
}
