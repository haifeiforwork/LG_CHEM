package com.sns.jdf.util;

public class CodeEntity extends com.sns.jdf.EntityData
{

    public CodeEntity() {

    }
    /**
     * @param code
     * @param value
     */
    public CodeEntity(String code, String value) {
        super();
        this.code = code;
        this.value = value;
    }
    //SUBTYPE
    public String code	    = null;
    public String value     = null;

    public String value1 = null;

    public CodeEntity(String code, String value, String value1) {
        super();
        this.code = code;
        this.value = value;
        this.value1 = value1;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValue1() {
        return value1;
    }

    public void setValue1(String value1) {
        this.value1 = value1;
    }
}