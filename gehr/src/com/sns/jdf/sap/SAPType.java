package com.sns.jdf.sap;

import org.apache.commons.lang.StringUtils;

public enum SAPType {
	LOCAL("com.sns.jdf.sap."), GLOBAL("com.sns.jdf.sap.global."), QASLOCAL("com.sns.jdf.sap.QAS."), QASGLOBAL("com.sns.jdf.sap.global.QAS.")
	, DEVLOCAL("com.sns.jdf.sap.DEV."), DEVGLOBAL("com.sns.jdf.sap.global.DEV.")
	, PRDLOCAL("com.sns.jdf.sap.PRD."), PRDGLOBAL("com.sns.jdf.sap.global.PRD.")
	, QASNLOCAL("com.sns.jdf.sap.QAS."), QASNGLOBAL("com.sns.jdf.sap.global.QASN.")
	, QASN1LOCAL("com.sns.jdf.sap.QAS."), QASN1GLOBAL("com.sns.jdf.sap.global.QASN1.")
	, QASN2LOCAL("com.sns.jdf.sap.QAS."), QASN2GLOBAL("com.sns.jdf.sap.global.QASN2.")
	, QASN3LOCAL("com.sns.jdf.sap.QAS."), QASN3GLOBAL("com.sns.jdf.sap.global.QASN3.")
	, QASN4LOCAL("com.sns.jdf.sap.QAS."), QASN4GLOBAL("com.sns.jdf.sap.global.QASN4.");
	
	private String propertyPerfx;
	
	SAPType(String propertyPrefx) {
		this.propertyPerfx = propertyPrefx;
	}

	public String getPropertyPerfx() {
		return propertyPerfx;
	}

	public boolean isLocal() {
		if(StringUtils.indexOf(this.name(), "LOCAL") > -1) return true;
		return false;
	}
	
}
