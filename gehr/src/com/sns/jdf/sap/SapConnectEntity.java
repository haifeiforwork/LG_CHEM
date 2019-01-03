package com.sns.jdf.sap;

import com.sap.mw.jco.IRepository;
import com.sap.mw.jco.JCO;

public class SapConnectEntity extends com.sns.jdf.EntityData {

	public IRepository repository;
	public int SAP_COUNT;
	public boolean isLoadBalancing = false;
	
	public int    SAP_MAXCONN         = 10;
	public  String SAP_CLIENT          = "";
	public  String SAP_USERNAME        = "";
	public  String SAP_PASSWD          = "";
	public  String SAP_LANGUAGE        = "";
	public  String SAP_HOST_NAME       = "";
	public  String SAP_SYSTEM_NUMBER   = "";
	public  String SAP_R3NAME          = "";
	public  String SAP_GROUP           = "";
	public  String SAP_REPOSITORY_NAME = "";
	public  String SID                 = "";
	
	private JCO.Pool pool = null; 
	
	public JCO.Pool getPool() {
		if(pool == null) pool = JCO.getClientPoolManager().getPool(SID);
		return pool;
	}
}
