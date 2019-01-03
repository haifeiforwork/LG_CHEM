package com.common.vo;

import org.apache.commons.beanutils.PropertyUtils;

import java.beans.PropertyDescriptor;

public class BaseVO {

    public String toString() {
        StringBuilder sb = new StringBuilder("\n");

        for(PropertyDescriptor property : PropertyUtils.getPropertyDescriptors(getClass())) {
            final String fieldName = property.getName();
            if("class".equals(fieldName)) continue;

            if (PropertyUtils.isReadable(this, fieldName)) {
                String fieldValue;
                try {
                    fieldValue = PropertyUtils.getProperty(this, fieldName).toString();
                } catch (Exception e) {
                    fieldValue = e.getMessage();
                }
                sb.append(String.format("{%s=%s} ", fieldName, fieldValue));
            }
        }

        return sb.toString();
    }
}
