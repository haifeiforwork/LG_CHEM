package com.common;

import com.sns.jdf.EntityData;
import com.sns.jdf.Logger;
import com.sns.jdf.util.DateTime;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Vector;

public class Utils {

	/**
	 * /resources/spring/*.context.xml 안에 선언된 bean 객체 를 가져온다 
	 * @param beanName
	 * @return
	 */
	public static <T> T getBean(String beanName) {
		return (T) getWebApplicationContext().getBean(beanName);
	}
	
	public static WebApplicationContext getWebApplicationContext() {
		return ContextLoader.getCurrentWebApplicationContext();
	}

	public static <K,V> LinkedHashMap <K,V> asMap(K key, V value, Object ... pairs) {
		LinkedHashMap<K, V> map = new LinkedHashMap<K, V>();

		map.put(key, value);

		for(int n = 0; n < pairs.length; n += 2) {
			map.put( (K) pairs[n], (V) pairs[n+1] );
		}

		return map;
	}

	public static int getSize(Collection<?> list) {
		return list == null ? 0 : list.size();
	}

	public static void setFieldValue(Object entity, String fieldName, Object value) {
		try {
			Field field = entity.getClass().getField(fieldName);
			if(field != null) field.set(entity, value);
		} catch (Exception e) {
			Logger.err.println("[" + fieldName + "] file not found!! ");
		}
	}

	public static  <T extends EntityData> T setFieldValue(T entity, Field field, String value) {
		try {

			if(field.getType() == Integer.class) field.set(entity, NumberUtils.toInt(value));
			else if(field.getType() == Float.class) field.set(entity, NumberUtils.toFloat(value));
			else if(field.getType() == Double.class) field.set(entity, NumberUtils.toDouble(value));
			else if(field.getType() == String.class) field.set(entity, value);
			else if(field.getType() == Date.class) field.set(entity, DateTime.parseDate(value));

		} catch (Exception e) {
			Logger.error(e);
		}
		return entity;
	}

	public static <T> T getFieldValue(Object entity, String fieldName, T defaultValue) {

		try {
			return (T) entity.getClass().getField(fieldName).get(entity);
		} catch (Exception e) {
			Logger.error(e);
		}

		return defaultValue;
	}

	public static <T> T getFieldValue(Object entity, String fieldName) {
		return getFieldValue(entity, fieldName, null);
	}

	public static <T> T indexOf(Collection<T> v, int idx) {
		int vSize = getSize(v);
		if(vSize == 0 || vSize <= idx) return null;
		return (T) CollectionUtils.index(v, idx);
	}

	public static <T> T indexOf(Collection<T> v, int idx, Class<T> defaultklass) {
		Object defaultValue = null;
		try{
			defaultValue = defaultklass.newInstance();
		} catch (Exception e) {
			Logger.error(e);
		}
		return (T) ObjectUtils.defaultIfNull(indexOf(v, idx), defaultValue);
	}

	/**
	 * n 값이 list의 마지막 값인지 확인
	 * @param list
	 * @param n
     * @return
     */
	public static boolean isLast(Collection list, int n) {
		int nSize = list == null ? 0 : list.size();
		if(n + 1 >= nSize ) return true;
		return false;
	}

	public static <T> Vector<T> asVector(T o, T ... args) {
		Vector<T> resultLsit = new Vector<T>();

		if(o != null && o instanceof Collection) resultLsit.addAll((Collection) o);
		else resultLsit.add(o);

		for(T arg : args) resultLsit.add(arg);

		return resultLsit;
	}

	/**
	 * request 값에서 klass에 해당하는 entity 값에 데이타를 셋팅해 리턴
	 * @param request
	 * @param klass
	 * @param <T>
	 * @return

	public static <T> T populate(HttpServletRequest request, Class<T> klass) {
		T o = null;
		try {
			o = klass.newInstance();
		} catch (InstantiationException e) {
			Logger.error(e);
		} catch (IllegalAccessException e) {
			Logger.error(e);
		}

		if(o == null) return null;

		try {
			RequestUtils.populate(o, request);
		} catch (ServletException e) {
			Logger.error(e);
		}

		return o;
	}
*/
}
