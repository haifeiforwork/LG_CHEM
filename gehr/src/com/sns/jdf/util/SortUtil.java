package com.sns.jdf.util;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;

import java.lang.reflect.Field;
import java.util.Collections;
import java.util.Comparator;
import java.util.StringTokenizer;
import java.util.Vector;

public class SortUtil {

    public static <T> Vector<T> sortStringAsc(Vector<T> list, final String fieldName) {
        Collections.sort(list, new Comparator<Object>() {
            public int compare(Object o1, Object o2) {
                return ((String) Utils.getFieldValue(o1, fieldName))
                        .compareTo((String) Utils.getFieldValue(o2, fieldName));
            }
        });
        return list;
    }

    // String Sort
    public static Vector sort( Vector vt, String fieldNames, String sortType ) throws GeneralException {
        try{
            StringTokenizer st = new StringTokenizer(sortType, ",");
            int count = 0;
            while( st.hasMoreTokens() ) {
                st.nextToken();
                count++;
            }
            if( count > 1 ){
                Logger.debug.println("sortMulti");
                return sortMulti( vt, fieldNames, sortType );
            } else {
                Logger.debug.println("sortVector");
                return sortVector( vt, fieldNames, sortType );
            }
        } catch( Exception e ){
            throw new GeneralException ( e, "NotSortException : "+e.toString() );
        }

    }
    
    // Number Sort
    public static Vector sort_num( Vector vt, String fieldNames, String sortType ) throws GeneralException {
        try{
            StringTokenizer st = new StringTokenizer(sortType, ",");
            int count = 0;
            while( st.hasMoreTokens() ) {
                st.nextToken();
                count++;
            }
            if( count > 1 ){
                Logger.debug.println("sortMulti_num");
                return sortMulti_num( vt, fieldNames, sortType );
            } else {
                Logger.debug.println("sortVector_num");
                return sortVector_num( vt, fieldNames, sortType );
            }
        } catch( Exception e ){
            throw new GeneralException ( e, "NotSortException : "+e.toString() );
        }

    }
    
    // String Sort
    private static Vector sortMulti( Vector vt, String fieldNames, String sortTypes ) throws GeneralException {
        try{
            Logger.debug.println( "fieldNames : "+ fieldNames +"  sortType : "+ sortTypes );
            Vector returnVt = new Vector(vt.size(), 1);
            for( int i = 0; i < vt.size(); i++ ) {
                for( int j = 0; j < returnVt.capacity(); j++ ) {
                    Object obj = vt.get(i);
                    if( i == j ) {
                        returnVt.add( j, obj );
                        break;
                    } else {
                        String value = compareObject( obj, returnVt.get(j), fieldNames ,sortTypes);
                        if( value.equals("insert") ) {
                            returnVt.insertElementAt( obj, j);
                            break;
                        } 
                    } 
                    
                }
            }
            return returnVt;
        } catch( Exception e ) {
            throw new GeneralException ( e, "NotSortException : "+e.toString() );
        }
    }
    
    // Number Sort
    private static Vector sortMulti_num( Vector vt, String fieldNames, String sortTypes ) throws GeneralException {
        try{
            Logger.debug.println( "fieldNames : "+ fieldNames +"  sortType : "+ sortTypes );
            Vector returnVt = new Vector(vt.size(), 1);
            for( int i = 0; i < vt.size(); i++ ) {
                for( int j = 0; j < returnVt.capacity(); j++ ) {
                    Object obj = vt.get(i);
                    if( i == j ) {
                        returnVt.add( j, obj );
                        break;
                    } else {
                        String value = compareObject_num( obj, returnVt.get(j), fieldNames ,sortTypes);
                        if( value.equals("insert") ) {
                            returnVt.insertElementAt(obj, j);
                            break;
                        } 
                    } 
                    
                }
            }
            return returnVt;
        } catch( Exception e ) {
            throw new GeneralException ( e, "NotSortException : "+e.toString() );
        }
    }
    
    // String Sort
    public static Vector sortVector( Vector vt, String fieldNames, String sortType ) throws GeneralException {
        try{
            Logger.debug.println( "fieldNames : "+ fieldNames +"  sortType : "+ sortType );
            Vector returnVt = new Vector(vt.size(), 1);
            for( int i = 0; i < vt.size(); i++ ) {
                for( int j = 0; j < returnVt.capacity(); j++ ) {
                    Object obj = vt.get(i);
                    if( i == j ) {
                        returnVt.add( j, obj );
                        break;
                    } else {
                        int value = compareObject( obj, returnVt.get(j), fieldNames );
                        if( (sortType.toLowerCase()).equals("asc") ) {
                            if( value > 0 ){
                                returnVt.insertElementAt( obj, j);
                                break;
                            } 
                        } else if ( (sortType.toLowerCase()).equals("desc") ) {
                            if( value < 0 ){
                                returnVt.insertElementAt( obj, j);
                                break;
                            } 
                        } else {
                           throw new BusinessException("정렬타입이 맞지 않습니다.");
                        }
                    } 
                }
            }
            return returnVt;
        } catch( Exception e ) {
            throw new GeneralException ( e, "NotSortException : "+e.toString() );
        }
    }
    
    // Number Sort
    public static Vector sortVector_num( Vector vt, String fieldNames, String sortType ) throws GeneralException {
        try{
            Logger.debug.println( "fieldNames : "+ fieldNames +"  sortType : "+ sortType );
            Vector returnVt = new Vector(vt.size(), 1);
            for( int i = 0; i < vt.size(); i++ ) {
                for( int j = 0; j < returnVt.capacity(); j++ ) {
                    Object obj = vt.get(i);
                    if( i == j ) {
                        returnVt.add( j, obj );
                        break;
                    } else {
                        int value = compareObject_num( obj, returnVt.get(j), fieldNames );
                        if( (sortType.toLowerCase()).equals("asc") ) {
                            if( value > 0 ){
                                returnVt.insertElementAt( obj, j);
                                break;
                            } 
                        } else if ( (sortType.toLowerCase()).equals("desc") ) {
                            if( value < 0 ){
                                returnVt.insertElementAt( obj, j);
                                break;
                            } 
                        } else {
                           throw new BusinessException("정렬타입이 맞지 않습니다.");
                        }
                    } 
                }
            }
            return returnVt;
        } catch( Exception e ) {
            throw new GeneralException ( e, "NotSortException : "+e.toString() );
        }
    }

    // String Sort
    private static String compareObject(Object obj1, Object obj2, String fieldNames, String sortTypes) throws GeneralException {
        StringTokenizer st = new StringTokenizer(fieldNames, ",");
        StringTokenizer sortSt = new StringTokenizer(sortTypes, ",");
        String compare = "pass";
        int comp = 0;
        while( st.hasMoreTokens() ) {
            String str  = st.nextToken();
            String str2 = sortSt.nextToken();
            try{
                comp = getValue( obj2, str ).compareTo( getValue( obj1, str ) );
                
                if( comp != 0 ){
                    if( (str2.toLowerCase()).equals("asc") && comp > 0 ){
                       compare="insert";
                    } else if(str2.equals("desc") && comp < 0 ){
                       compare="insert";
                    }
                    break;
                }
            } catch ( Exception e ) {
                throw new GeneralException( e );
            }
        }
        return compare;
    }

    // Number Sort
    private static String compareObject_num(Object obj1, Object obj2, String fieldNames, String sortTypes) throws GeneralException {
        StringTokenizer st = new StringTokenizer(fieldNames, ",");
        StringTokenizer sortSt = new StringTokenizer(sortTypes, ",");
        String compare = "pass";
        int comp = 0;
        while( st.hasMoreTokens() ) {
            String str  = st.nextToken();
            String str2 = sortSt.nextToken();
            try{
                double num1 = Double.parseDouble(getValue( obj1, str ));
                double num2 = Double.parseDouble(getValue( obj2, str ));

                if( num1 > num2 ) {
                    comp = -1;
                } else if( num1 < num2 ) {
                    comp =  1;
                } else {
                    comp =  0;
                }
                
                if( comp != 0 ){
                    if( (str2.toLowerCase()).equals("asc") && comp > 0 ){
                       compare="insert";
                    } else if(str2.equals("desc") && comp < 0 ){
                       compare="insert";
                    }
                    break;
                }
            } catch ( Exception e ) {
                throw new GeneralException( e );
            }
        }
        return compare;
    }
    
    // String Sort
    private static int compareObject(Object obj1, Object obj2, String fieldNames) throws GeneralException {
        StringTokenizer st = new StringTokenizer(fieldNames, ",");
        int comp = 0;
        while( st.hasMoreTokens() ) {
            String str = st.nextToken();
            try{
                comp = getValue( obj2, str ).compareTo( getValue( obj1, str ) );
                
                if( comp != 0 ){
                    break;
                }
            } catch ( Exception e ) {
                throw new GeneralException( e );
            }
        }
        return comp;
    }

    // Number Sort
    private static int compareObject_num(Object obj1, Object obj2, String fieldNames) throws GeneralException {
        StringTokenizer st = new StringTokenizer(fieldNames, ",");
        int comp = 0;
        while( st.hasMoreTokens() ) {
            String str = st.nextToken();
            try{
                double num1 = Double.parseDouble(getValue( obj1, str ));
                double num2 = Double.parseDouble(getValue( obj2, str ));

                if( num1 > num2 ) {
                    comp = -1;
                } else if( num1 < num2 ) {
                    comp =  1;
                } else {
                    comp =  0;
                }
                
                if( comp != 0 ){
                    break;
                }
            } catch ( Exception e ) {
                throw new GeneralException( e );
            }
        }
        return comp;
    }

    private static String getValue( Object obj, String fieldName ) throws GeneralException {
        try{
            Class c = obj.getClass();
            Field[] fields = c.getFields();
            String val = "";
            for (int i=0 ; i<fields.length; i++) {
                if( fields[i].getName().equals( fieldName ) ){
                    val = ( String )fields[i].get( obj );
                    if ( val == null) {
                        val = "";
                    }
                }
            }
            return val;
        } catch( Exception e ) {
            throw new GeneralException( e, "Not return Value.. Exception e : "+e.toString() );
        }
    }

    private static String getValue( Object obj, int index ) throws GeneralException {
        try{
            Class c = obj.getClass();
            Field[] fields = c.getFields();
            String val = ( String )fields[index].get( obj );
            if ( val == null ) {
                val = "";
            }
            return val;
        } catch( Exception e ) {
            throw new GeneralException( e, "Not return Value.. Exception e : "+e.toString() );
        }
    }
}

