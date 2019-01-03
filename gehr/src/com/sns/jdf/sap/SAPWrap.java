/********************************************************************************/
/*   Program ID   : SAPWrap.java                                                */
/*   Description  :                                                             */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       :   [CSR ID:3413389] ȣĪ����(����/����)�� ���� �λ� ȭ�� ����    2017-06-15 eunha */
/*                                                                              */
/********************************************************************************/

package com.sns.jdf.sap;

import com.common.Global;
import com.common.RFCReturnEntity;
import com.common.Utils;
import com.common.constant.Server;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.FieldIterator;
import com.sap.mw.jco.JCO.Function;
import com.sap.mw.jco.JCO.ParameterList;
import com.sap.mw.jco.JCO.Table;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.util.*;

@SuppressWarnings("rawtypes")
public class SAPWrap {

    public static String SYSTEM_LOCALE_DATE = "SYSTEM_LOCALE_DATE";

    protected Global g;

    private static Map<SAPType, SapConnectEntity> connectMap;

    private SAPType sapType;	// �⺻���� ����SAPType.LOCAL;

    private RFCReturnEntity rfcReturnEntity;

    public SAPWrap() {
        g = Utils.getBean("global");
        sapType = g.getSapType();
        Logger.debug.println();
        Logger.debug.println(this, "SAPWrap instantiation : " + sapType);
    }

    public SAPWrap(SAPType sapType) {
        this();
        setSapType(sapType);
    }

    public SAPWrap(SAPType sapType, Server server) {
        this();
        setSapType(sapType, server);
    }

    public SAPType getSapType() {
        return sapType;
    }

    public void setSapType(SAPType sapType) {
        this.sapType = sapType;
    }

    public void setSapType(SAPType sapType, Server server) {
        if (server == null || server == Server.DEFAULT)
            this.sapType = sapType;
        else {
            try {
                this.sapType = SAPType.valueOf(server.name() + sapType.name());
            } catch (Exception e) {
                this.sapType = sapType;
            }
        }
    }

    static {
        if (connectMap == null)
            connectMap = new HashMap<SAPType, SapConnectEntity>();
        try {

            /*Config conf = new Configuration(SAPWrap.server);*/
            Config conf = new Configuration();

            for (SAPType sType : SAPType.values()) {
                if (connectMap.get(sType) != null && StringUtils.isNotEmpty(connectMap.get(sType).SID))
                    continue;

                SapConnectEntity sapCon = new SapConnectEntity();
                try {
                    sapCon.isLoadBalancing = conf.getBoolean(sType.getPropertyPerfx() + "SAP_LOAD");

                    sapCon.SID = conf.get(sType.getPropertyPerfx() + "SID");
                    sapCon.SAP_MAXCONN = conf.getInt(sType.getPropertyPerfx() + "SAP_MAXCONN", 100);
                    sapCon.SAP_CLIENT = conf.get(sType.getPropertyPerfx() + "SAP_CLIENT");
                    sapCon.SAP_USERNAME = conf.get(sType.getPropertyPerfx() + "SAP_USERNAME");
                    sapCon.SAP_PASSWD = conf.get(sType.getPropertyPerfx() + "SAP_PASSWD");
                    sapCon.SAP_LANGUAGE = conf.get(sType.getPropertyPerfx() + "SAP_LANGUAGE");
                    sapCon.SAP_HOST_NAME = conf.get(sType.getPropertyPerfx() + "SAP_HOST_NAME");
                    sapCon.SAP_REPOSITORY_NAME = conf.get(sType.getPropertyPerfx() + "SAP_REPOSITORY_NAME");
                } catch (Exception e) {
                    Logger.error(e);
                }
                if (JCO.getClientPoolManager().getPool(sapCon.SID) == null) {

                    Logger.info.println("2 SID : " + sapCon.SID);
                    if (sapCon.isLoadBalancing) {

                        sapCon.SAP_R3NAME = conf.get(sType.getPropertyPerfx() + "SAP_R3NAME");
                        sapCon.SAP_GROUP = conf.get(sType.getPropertyPerfx() + "SAP_GROUP");

                        JCO.addClientPool(sapCon.SID, sapCon.SAP_MAXCONN, sapCon.SAP_CLIENT, sapCon.SAP_USERNAME, sapCon.SAP_PASSWD, sapCon.SAP_LANGUAGE, sapCon.SAP_HOST_NAME, sapCon.SAP_R3NAME,
                                        sapCon.SAP_GROUP);
                        sapCon.repository = new JCO.Repository(sapCon.SAP_REPOSITORY_NAME, sapCon.SID);

                        Logger.info.println(" SAP_R3NAME : " + sapCon.SAP_R3NAME);
                        Logger.info.println(" SAP_GROUP : " + sapCon.SAP_GROUP);
                    } else {

                        sapCon.SAP_SYSTEM_NUMBER = conf.get(sType.getPropertyPerfx() + "SAP_SYSTEM_NUMBER");

                        JCO.addClientPool(sapCon.SID, sapCon.SAP_MAXCONN, sapCon.SAP_CLIENT, sapCon.SAP_USERNAME, sapCon.SAP_PASSWD, sapCon.SAP_LANGUAGE, sapCon.SAP_HOST_NAME,
                                        sapCon.SAP_SYSTEM_NUMBER);
                        sapCon.repository = new JCO.Repository(sapCon.SAP_REPOSITORY_NAME, sapCon.SID);
                        Logger.info.println(" SAP_HOST_NAME : " + sapCon.SAP_HOST_NAME);
                        Logger.info.println(" SAP_SYSTEM_NUMBER : " + sapCon.SAP_SYSTEM_NUMBER);
                    } // end if
                } else {
                    Logger.info.println("1 SID : " + sapCon.SID);
                    sapCon.repository = new JCO.Repository(sapCon.SAP_REPOSITORY_NAME, sapCon.SID);
                } // end if

                connectMap.put(sType, sapCon);

                Logger.info.println(" SAP_MAXCONN : " + sapCon.SAP_MAXCONN);
                Logger.info.println(" SAP_USERNAME : " + sapCon.SAP_USERNAME);
                Logger.info.println(" SAP_PASSWD : " + sapCon.SAP_PASSWD);
            }

        } catch (Exception ex) {
            Logger.info.println("Can not Configuration : " + ex.toString());
        }
    } // end static

    private void count(String flag) throws GeneralException {
        if (flag.equals("x")) { // connection�� �߰��Ǵ°��
            connectMap.get(sapType).SAP_COUNT = connectMap.get(sapType).SAP_COUNT + 1;
        } else {// connection�� ����Ǵ°��
            connectMap.get(sapType).SAP_COUNT = connectMap.get(sapType).SAP_COUNT - 1;
        }
        Logger.sap.println(this, "connection counting : " + connectMap.get(sapType).SAP_COUNT);
    }

    public JCO.Client getClient() throws GeneralException {
        try {
            Logger.info.println(this, "getClient SID : " + connectMap.get(sapType).SID);
            JCO.Client mConnection = JCO.getClient(connectMap.get(sapType).SID, true);
            Logger.info.println(this, "getConnection : " + mConnection.toString());
            // synchronized(this){
            count("x");
            // }
            return mConnection;
        } catch (Exception ex) {
            Logger.sap.println(this, "Can not getConnection : " + ex.toString());
            throw new GeneralException(ex);
        }
    }

    public Function createFunction(String functionName) throws GeneralException {
        try {
            JCO.Pool pool = connectMap.get(sapType).getPool();
            Logger.sap.println(this, "********** Pool size : " + pool.getNumUsed() + "/" + pool.getMaxPoolSize() + "(" + pool.getMaxUsed() + ")");
            // Logger.info.println("[SAPWrap ===[createFunction]pool size= " + pool.getNumUsed() +"/"+ pool.getMaxPoolSize() +"(" +pool.getMaxUsed() + ")");
            Logger.info.println();
            Logger.info.println(this, "********** RFC Name : " + functionName);

            return connectMap.get(sapType).repository.getFunctionTemplate(functionName.toUpperCase()).getFunction();
        } catch (Exception ex) {
            Logger.error(ex);
            throw new GeneralException(ex);
        }
    }

    public void excute(JCO.Client mConnection, Function function) throws GeneralException {
        WebUserData userData = WebUtil.getSessionMSSUser(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());

        if (userData == null || StringUtils.isEmpty(userData.empNo))
            userData = WebUtil.getSessionUser(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());

        excute(mConnection, function, userData);
    }

    public void excute(JCO.Client mConnection, Function function, WebUserData userData) throws GeneralException {
        try {

            String I_SPRSL = null;
            if (Locale.KOREAN.equals(g.getLocale()))
                I_SPRSL = "3";
            else if (Locale.ENGLISH.equals(g.getLocale()))
                I_SPRSL = "2";
            else if (Locale.CHINESE.equals(g.getLocale()))
                I_SPRSL = "1";

            setField(function, "I_SPRSL", I_SPRSL);

            if (userData != null) {
                setField(function, "I_MOLGA", userData.area.getMolga());

            }
            // [CSR ID:3413389] ȣĪ����(����/����)�� ���� �λ� ȭ�� ���� 2017-06-15 eunha start
            WebUserData userLoginData = WebUtil.getSessionUser(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());

            if (userLoginData != null) {
                if (userLoginData.e_authorization.indexOf("H") > -1)
                    setField(function, "I_SFLAG", "Y");
                else
                    setField(function, "I_SFLAG", "");
            }
            // [CSR ID:3413389] ȣĪ����(����/����)�� ���� �λ� ȭ�� ���� 2017-06-15 eunha end

            boolean trace = true;
            long start = 0, end = 0;
            if (trace) {
                start = System.currentTimeMillis();
            }
            mConnection.execute(function);
            if (trace) {
                end = System.currentTimeMillis();
                Logger.debug.println(this, "end(elapsed : " + (end - start) + "ms)");
                Logger.debug.println();
            }

            try {
                rfcReturnEntity = getStructor(RFCReturnEntity.class, function, "E_RETURN", null);
            } catch (Exception e) {
                Logger.err.println(this, "------ E_RETURN structure ���� ��� ����");
            }

        } catch (Exception ex) {
            Logger.sap.println(this, "excute�� �Ҽ� �����ϴ�." + ex.toString());
            throw new GeneralException(ex);
        }
    }

    public void close(JCO.Client mConnection) {
        try {
            if (mConnection != null) {
                JCO.releaseClient(mConnection);
                // synchronized(this){
                count("y");
                // }
            }
            Logger.sap.println(this, "releseConnection");
        } catch (Exception ex) {
            Logger.sap.println(this, "releseConnectionException :" + ex.toString());
        }
    }

    // �ѱ�/���� ������
    public static String fromSAP(String data) {
        try {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            if (conf.getBoolean("com.sns.jdf.util.SAPConversion")) {
                return com.sns.jdf.util.DataUtil.E2K(data);
            } else {
                return data;
            }
        } catch (Exception e) {
            Logger.error(e);
            return data;
        }
    }

    public static String toSAP(String data) {
        try {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            if (conf.getBoolean("com.sns.jdf.util.SAPConversion")) {
                return com.sns.jdf.util.DataUtil.K2E(data);
            } else {
                return data;
            }
        } catch (Exception e) {
            Logger.error(e);
            return data;
        }
    }

    ////////////////////////////////////////////////
    // setTable : ���� ���� ����...
    public void setTable(Function function, String tableName, Vector entityVector) throws GeneralException {
        setTable(function, tableName, entityVector, "");
    }

    // setStructor : ���� ���� ����...
    public void setStructor(Function function, String structureName, Object data) throws GeneralException {
        setStructor(function, structureName, data, "");
    }

    public void setFields(Function function, Object data) throws GeneralException {
        setFields(function, data, "");
    }

    public void setField(Function function, String fieldName, String value) throws GeneralException {
        setField(function, fieldName, value, "");
    }

    // dongxiaomian 20140701 begin
    protected void setField1(JCO.Function function, String fieldName, String value, String fieldName1, String value1) throws GeneralException {
        setField1(function, fieldName, value, "", fieldName1, value1);
    }
    // dongxiaomian 20140701 end

    ////////////////////////////////////////
    // ���� trim() ���� �ʰ� ��ȯ��;
    public Vector getTableNoTrim(String entityName, Function function, String tableName) throws GeneralException {
        return getTableNoTrim(entityName, function, tableName, "");
    }

    public Vector getTable(String entityName, Function function, String tableName) throws GeneralException {
        return getTable(entityName, function, tableName, "");
    }

    public Vector getTable(Class entityClass, Function function, String tableName) throws GeneralException {
        return getTable(entityClass, function, tableName, "");
    }

    public Vector getTable(Function function, String tableName) throws GeneralException {
        return getHashMapTable(function, tableName);
    }

    /**
     * �ٷμҵ� ��õ¡�� ������ PDF Dataó���� ���� �߰��� �Լ�
     * [CSR : C20100427_56011] �ٷμҵ��õ¡��������/���ټ���õ¡������ PDF��ȯ ��û �輼�� 2010.04.28
     * [C20100510_63186] ESS �޿����� ���� ���� : ��õ¡�� �߰� ���� (2010.05.17 �輼��)
     */
    public Vector getHashMapTable(Function function, String tableName) throws GeneralException {
        Vector retvt = new Vector();
        try {
            JCO.Table table = function.getTableParameterList().getTable(tableName);

            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);

                Hashtable data = new Hashtable();

                // Logger.debug.println("");
                for (int k = 0; k < table.getNumColumns(); k++) {
                    data.put(table.getName(k), table.getValue(table.getName(k)));
                    // Logger.debug.println(table.getName(k) + " -> ["+table.getValue(table.getName(k))+"]");
                }
                retvt.addElement(data);
            }
            Logger.debug.println(this, "RETURN " + tableName + " (" + table.getNumRows() + " Records)");
            return retvt;
        } catch (Exception ex) {
            Logger.debug.println(this, "getHashMapTable() ���� ���ܹ߻� " + ex.toString());
            throw new GeneralException(ex);
        }
    }

    public <T> T getStructor(T data, Function function, String structureName) throws GeneralException {
        return getStructor(data, function, structureName, "");
    }

    public <T> T getFields(T data, Function function) throws GeneralException {
        return getFields(data, function, "");
    }

    public String getField(String fieldName, Function function) throws GeneralException {
        return getField(fieldName, function, "");
    }

    // dongxiaomian 20140701 begin
    protected String getField1(String fieldName, String fieldName1, JCO.Function function) throws GeneralException {
        return getField1(fieldName, fieldName1, function, "");
    }
    // dongxiaomian 20140701 end

    ////////////////////////////////////////
    public Vector<CodeEntity> getCodeVector(Function function, String tableName) throws GeneralException {
        Vector<CodeEntity> retvt = new Vector();
        try {
            JCO.Table table = function.getTableParameterList().getTable(tableName);
            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);

                com.sns.jdf.util.CodeEntity ret = new com.sns.jdf.util.CodeEntity();

                ret.code = table.getString(0);
                ret.value = table.getString(1);
                // Logger.debug.println(this, ret.toString());
                DataUtil.fixNullAndTrim(ret);
                retvt.addElement(ret);
            }
            Logger.debug.println(this, "********** getCodeVector() tableName   : " + tableName);
            Logger.debug.println(this, "********** getCodeVector() tableResult : " + retvt);
        } catch (Exception ex) {
            Logger.debug.println(this, "getCodeVector( Function function, String tableName)���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
        return retvt;
    }

    ////////////////////////////////////////
    public Vector getCodeVector(Function function, String tableName, String codeField, String valueField) throws GeneralException {
        Vector retvt = new Vector();
        try {
            JCO.Table table = function.getTableParameterList().getTable(tableName);
            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);

                com.sns.jdf.util.CodeEntity ret = new com.sns.jdf.util.CodeEntity();

                ret.code = table.getString(codeField);
                ret.value = table.getString(valueField);
                // Logger.debug.println(this, ret.toString());
                DataUtil.fixNullAndTrim(ret);
                retvt.addElement(ret);
            }
            Logger.debug.println(this, "********** getCodeVector() tableName   : " + tableName);
            Logger.debug.println(this, "********** getCodeVector() tableResult : " + retvt);
        } catch (Exception ex) {
            Logger.debug.println(this, "getCodeVector( Function function, String tableName, String codeField, String valueField )���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
        return retvt;
    }

    /*
     *  �ʵ�� ���ξ �پ �ʵ���� ���� �ٸ���� ��Ī�ϴ� �޼ҵ�...
     *  ex) XxxData.APPL_PERNR       ===>    Function�� PERNR
     *
     */
    public void setTable(Function function, String tableName, Vector entityVector, String prev) throws GeneralException {

        try {
            if (!function.getTableParameterList().hasField(tableName)) {
                Logger.err.println(this, "[ " + tableName + " ] Table not exist!");
                return;
            }
            JCO.Table table = function.getTableParameterList().getTable(tableName);
            if (table == null)
                Logger.debug.println(this, "table is null");
            else
                Logger.debug.println(this, "table : " + table.toString());

            int alength = entityVector.size();
            Logger.debug.println(this, "setTable ENTITY size :" + alength);

            for (int i = 0; i < alength; i++) {
                table.appendRow();
                Object data = entityVector.get(i);
                DataUtil.fixNull(data);

                Class c = data.getClass();
                Field[] fields = c.getFields();

                for (int k = 0; k < fields.length; k++) {
                    String fieldName = fields[k].getName();
                    if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                        fieldName = fieldName.substring(prev.length());
                    }

                    if (table.hasField(fieldName)) {
                        if (fields[k].get(data) instanceof Date) {
                            table.setValue(fields[k].get(data), fieldName);
                        } else {
                            String value = (String) fields[k].get(data);

                            if (StringUtils.isBlank(value))
                                table.setValue(value, fieldName);
                            else {
                                switch (table.getField(fieldName).getType()) {
                                case JCO.TYPE_BCD:
                                    table.setValue(StringUtils.remove(value, ","), fieldName);
                                    break;
                                case JCO.TYPE_DATE:
                                    String removeValue = WebUtil.printDate(value);
                                    if (StringUtils.isBlank(removeValue))
                                        continue;

                                    table.setValue(DateUtils.parseDate(DataUtil.removeSeparate(value), new String[] { "yyyyMMdd" }), fieldName);
                                    break;
                                default:
                                    table.setValue(value, fieldName);
                                    break;

                                }
                            }
                        }

                        Logger.debug.println(this, "[" + k + "] " + fieldName + " : " + fields[k].get(data));
                    }
                }
            }
            function.getTableParameterList().setValue(table, tableName);

            Logger.debug.println(this, "********** getTable() tableName : " + tableName);
        } catch (Exception ex) {
            Logger.debug.println(this, "setTable(Function function, String tableName, Vector entityVector)���� ���ܹ߻� ");
            Logger.debug.println(this, ex.toString());
            throw new GeneralException(ex);
        }
    }

    // setStructor : ���� ���� ����...
    public void setStructor(Function function, String structureName, Object data, String prev) throws GeneralException {
        try {
            JCO.Structure structure = function.getImportParameterList().getStructure(structureName);

            DataUtil.fixNull(data);
            Class c = data.getClass();
            Field[] fields = c.getFields();

            for (int k = 0; k < fields.length; k++) {
                String fieldName = fields[k].getName();
                if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                    fieldName = fieldName.substring(prev.length());
                }
                if (structure.hasField(fieldName)) {
                    // structure.setValue( structure , fieldName);
                    structure.setValue((String) fields[k].get(data), fieldName);
                }
            }
            // Logger.debug.println(this, "structure : "+structure.toString());
            function.getImportParameterList().setValue(structure, structureName);

            Logger.debug.println(this, "********** setStructor() structureName : " + structureName);
        } catch (Exception ex) {
            Logger.debug.println(this, "getStructor(Object data, Function function, String structureName)���� ���ܹ߻� ");
            Logger.info.println(this, "���� ã�� rdcamel1 : " + ex.toString());
            throw new GeneralException(ex);
        }
    }

    /**
     * data frield���� I_ ���� �ʵ���� ���� �����´�
     * 
     * @param function
     * @param data
     * @param prev
     * @throws GeneralException
     */
    public void setInputFields(Function function, Object data, String prev) throws GeneralException {
        prev = StringUtils.defaultString(prev);
        try {
            DataUtil.fixNull(data);
            Class c = data.getClass();
            Field[] fields = c.getFields();

            for (int k = 0; k < fields.length; k++) {
                String fieldName = fields[k].getName();
                if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                    fieldName = fieldName.substring(prev.length());
                }
                fieldName = "I_" + fieldName;
                if (function.getImportParameterList().hasField(fieldName)) {
                    function.getImportParameterList().setValue((String) fields[k].get(data), fieldName);
                }
            }

            Logger.debug.println(this, "********** setFields() " + data.toString());
        } catch (Exception ex) {
            Logger.debug.println(this, "setFields(Function function, Object data))���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
    }

    public void setFields(Function function, Object data, String prev) throws GeneralException {
        try {
            DataUtil.fixNull(data);
            Class c = data.getClass();
            Field[] fields = c.getFields();

            for (int k = 0; k < fields.length; k++) {
                String fieldName = fields[k].getName();
                if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                    fieldName = fieldName.substring(prev.length());
                }

                // && fields[k].get(data) != null �߰� �� null�� ��� �⺻�� "" ���� ��:�⺻�� ���õ�
                if (function.getImportParameterList().hasField(fieldName) && fields[k].get(data) != null) {
                    if (String.class.equals(fields[k].getClass())) {
                        function.getImportParameterList().setValue((String) fields[k].get(data), fieldName);
                    } else {
                        function.getImportParameterList().setValue(fields[k].get(data), fieldName);
                    }

                    Logger.debug.println(this, "[" + k + "] " + fieldName + " : " + fields[k].get(data));
                }
            }
            // Logger.debug.println(this, "function : "+function.toString());
            // Logger.debug.println(this, "ImportParameterList : "+function.getImportParameterList().toString());
            Logger.debug.println(this, "********** setFields() " + data.toString());
        } catch (Exception ex) {
            Logger.error(ex);
            Logger.debug.println(this, "setFields(Function function, Object data))���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
    }

    public void setField(Function function, String fieldName, String value, String prev) throws GeneralException {
        try {
            if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                fieldName = fieldName.substring(prev.length());
            }
            if (function.getImportParameterList() != null && function.getImportParameterList().hasField(fieldName))

                if (StringUtils.isNotBlank(value) && function.getImportParameterList().getField(fieldName).getType() == JCO.TYPE_DATE) {
                    function.getImportParameterList().setValue(DateUtils.parseDate(value.replaceAll("[^\\d]", ""), new String[] { "yyyyMMdd" }), fieldName);
                } else {
                    function.getImportParameterList().setValue(value, fieldName);
                }

            // Logger.debug.println(this, "ImportParameterList : "+function.getImportParameterList().toString());
            Logger.debug.println(this, "********** setField() " + fieldName + " : " + value);
        } catch (Exception ex) {
            Logger.debug.println(this, "setField(Function function, String fieldName, String value)���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
    }

    // dongxiaomian 20140701 begin
    protected void setField1(JCO.Function function, String fieldName, String value, String prev, String fieldName1, String value1) throws GeneralException {
        try {
            if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                fieldName = fieldName.substring(prev.length());
            }
            if (fieldName1.length() > prev.length()) {
                fieldName1 = fieldName1.substring(prev.length());
            }

            if (function.getImportParameterList() != null && function.getImportParameterList().hasField(fieldName)) {

                if (StringUtils.isNotBlank(value) && function.getImportParameterList().getField(fieldName).getType() == JCO.TYPE_DATE) {
                    function.getImportParameterList().setValue(DateUtils.parseDate(value.replaceAll("[^\\d]", ""), new String[] { "yyyyMMdd" }), fieldName);
                } else {
                    function.getImportParameterList().setValue(value, fieldName);
                }
            }

            if (function.getImportParameterList() != null && function.getImportParameterList().hasField(fieldName1)) {

                if (StringUtils.isNotBlank(value1) && function.getImportParameterList().getField(fieldName1).getType() == JCO.TYPE_DATE) {
                    function.getImportParameterList().setValue(DateUtils.parseDate(value1.replaceAll("[^\\d]", ""), new String[] { "yyyyMMdd" }), fieldName1);
                } else {
                    function.getImportParameterList().setValue(value1, fieldName1);
                }
            }

            // function.getImportParameterList().setValue( value , fieldName);
            // function.getImportParameterList().setValue( value1 , fieldName1);
            // Logger.debug.println(this, "ImportParameterList : "+function.getImportParameterList().toString());
            Logger.debug.println(this, "********** setField1() : " + fieldName);
            Logger.debug.println(this, "********** setField1() : " + fieldName1);
        } catch (Exception ex) {
            Logger.debug.println(this, "setField1(JCO.Function function, String fieldName, String value)���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
    }
    // dongxiaomian 20140701 end

    ////////////////////////////////////////

    // ���� trim() ���� �ʰ� ��ȯ��;
    public Vector getTableNoTrim(String entityName, Function function, String tableName, String prev) throws GeneralException {
        Vector retvt = new Vector();
        try {
            JCO.Table table = function.getTableParameterList().getTable(tableName);
            // Logger.debug.println(this, "[]Package ��ΰ� �����־���� : "+entityName);
            Class c = Class.forName(entityName);
            Object data = null;
            Field[] fields = c.getFields();
            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);
                data = c.newInstance();
                for (int k = 0; k < fields.length; k++) {
                    String fieldName = fields[k].getName();
                    if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                        fieldName = fieldName.substring(prev.length());
                    }
                    if (table.hasField(fieldName)) {
                        fields[k].set(data, table.getString(fieldName));
                    }
                }
                // Logger.debug.println(this, data.toString());
                DataUtil.fixNull(data);    // <=== No Trim()
                retvt.addElement(data);
            }
            Logger.debug.println(this, "********** getTableNoTrim() tableName : " + tableName);
        } catch (Exception ex) {
            Logger.debug.println(this, "getTable(String entityName, Function function, String functionName)���� ���ܹ߻� ");
            Logger.debug.println(this, "entityName�� Package ��ΰ� �����־���� .. Ȯ�ο� ");
            throw new GeneralException(ex);
        }
        return retvt;
    }

    public Vector getTable(String entityName, Function function, String tableName, String prev) throws GeneralException {
        try {
            return getTable(Class.forName(entityName), function, tableName, prev);
        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

    public Vector getTable(Class entityClass, Function function, String tableName, String prev) throws GeneralException {
        Vector retvt = new Vector();
        prev = StringUtils.defaultString(prev);
        try {
            JCO.Table table = function.getTableParameterList().getTable(tableName);
            // Logger.debug.println(this, "[]Package ��ΰ� �����־���� : "+entityName);
            Object data = null;
            Field[] fields = entityClass.getFields();
            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);
                data = entityClass.newInstance();
                for (int k = 0; k < fields.length; k++) {
                    try {
                        String fieldName = fields[k].getName();
                        if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                            fieldName = fieldName.substring(prev.length());
                        }
                        if (table.hasField(fieldName)) {
                            /*if(table.getType(fieldName) == JCO.TYPE_TIME) {
                                Logger.debug("TYPE_TIME fieldName : " + table.getTime(fieldName));
                            }*/
                            fields[k].set(data, table.getString(fieldName));
                        }
                    } catch (Exception e) {
                        Logger.err.print(this, "getField error");
                        Logger.info.println(this, "getField error log : " + e.toString());
                    }
                }
                Logger.debug.println(this, data.toString());
                DataUtil.fixNullAndTrim(data);
                retvt.addElement(data);
            }
            Logger.debug.println(this, "********** getTable() tableName : " + tableName);
        } catch (Exception ex) {
            Logger.error(ex);
            Logger.debug.println(this, "getTable(String entityName, Function function, String functionName)���� ���ܹ߻� ");
            Logger.debug.println(this, "entityName�� Package ��ΰ� �����־���� .. Ȯ�ο� ");
            throw new GeneralException(ex);
        }
        return retvt;
    }

    /**
     * prev + data�� �ʵ�� �� ���� �����´�
     * 
     * @param data
     * @param function
     * @param structureName
     * @param prev
     * @param <T>
     * @return
     * @throws GeneralException
     */
    public <T> T getStructor(T data, Function function, String structureName, String prev) throws GeneralException {
        try {
            if (function.getExportParameterList() != null && function.getExportParameterList().hasField(structureName)) {
                prev = StringUtils.defaultString(prev);
                JCO.Structure structure = function.getExportParameterList().getStructure(structureName);

                Class c = data.getClass();
                Field[] fields = c.getFields();

                for (int k = 0; k < fields.length; k++) {
                    String fieldName = fields[k].getName();

                    if (structure.hasField(prev + fieldName)) {
                        String value = structure.getString(prev + fieldName);
                        fields[k].set(data, value);
                        Logger.debug.println(this, "[" + fieldName + "] : " + value);
                    }
                }
                DataUtil.fixNullAndTrim(data);

                // Logger.debug.println(this, "data : "+data.toString());
                Logger.debug.println(this, "********** getStructor() structureName : " + structureName);
            }
        } catch (Exception ex) {
            Logger.debug.println(this, "getStructor(Object data, Function function, String structureName)���� ���ܹ߻� ");
            Logger.info.println(this, "���� ã�� rdcamel2 : " + ex.toString());
            // throw new GeneralException(ex);
            return null;
        }

        return data;
    }

    public <T> T getStructor(Class<T> klass, Function function, String structureName, String prev) throws GeneralException {
        try {
            return getStructor(klass.newInstance(), function, structureName, prev);
        } catch (Exception e) {
            Logger.error(e);
        }
        return null;
    }

    public <T> T getFields(T data, Function function, String prev) throws GeneralException {
        prev = StringUtils.defaultString(prev);

        try {
            Class c = data.getClass();
            Field[] fields = c.getFields();

            for (int k = 0; k < fields.length; k++) {
                String fieldName = fields[k].getName();
                if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                    fieldName = fieldName.substring(prev.length());
                }

                if (function.getExportParameterList().hasField(fieldName)) {
                    fields[k].set(data, function.getExportParameterList().getString(fieldName));
                }
            }
            DataUtil.fixNullAndTrim(data);

            // Logger.debug.println(this, "data : "+data.toString());
            Logger.debug.println(this, "********** getFields() " + data.toString());
        } catch (Exception ex) {
            Logger.debug.println(this, "getFields(Object data, Function function)���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
        return data;
    }

    /**
     * entity���� E_ ���� ���� �ʵ���� �����´�
     * 
     * @param klass
     * @param function
     * @param structureName
     * @param prev
     * @param <T>
     * @return
     * @throws GeneralException
     */
    public <T> T getExportFields(Class<T> klass, Function function, String structureName, String prev) throws GeneralException {
        try {
            return getExportFields(klass.newInstance(), function, prev);
        } catch (Exception e) {
            Logger.error(e);
        }
        return null;
    }

    /**
     * entity���� E_ ���� ���� �ʵ���� �����´�
     * 
     * @param data
     * @param function
     * @param prev
     * @param <T>
     * @return
     * @throws GeneralException
     */
    public <T> T getExportFields(T data, Function function, String prev) throws GeneralException {
        prev = StringUtils.defaultString(prev);

        try {
            Class c = data.getClass();
            Field[] fields = c.getFields();

            for (int k = 0; k < fields.length; k++) {
                String fieldName = fields[k].getName();
                if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
                    fieldName = fieldName.substring(prev.length());
                }
                fieldName = "E_" + fieldName;

                if (function.getExportParameterList().hasField(fieldName)) {
                    fields[k].set(data, function.getExportParameterList().getString(fieldName));
                }
            }
            DataUtil.fixNullAndTrim(data);

            // Logger.debug.println(this, "data : "+data.toString());
            Logger.debug.println(this, "********** getFields() " + data.toString());
        } catch (Exception ex) {
            Logger.debug.println(this, "getFields(Object data, Function function)���� ���ܹ߻� ");
            throw new GeneralException(ex);
        }
        return data;
    }

    public String getField(String fieldName, Function function, String prev) throws GeneralException {
        if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
            fieldName = fieldName.substring(prev.length());
        }
        ParameterList exportParamList = function.getExportParameterList();
        if (exportParamList.hasField(fieldName)) {
            String fieldValue = function.getExportParameterList().getString(fieldName);
            Logger.debug.println(this, "********** getField() " + fieldName + " : " + fieldValue);
            return StringUtils.trim(fieldValue);
        }
        return null;
    }

    // dongxiaomian 20140701 begin
    protected String getField1(String fieldName, String fieldName1, JCO.Function function, String prev) throws GeneralException {
        if (fieldName.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
            fieldName = fieldName.substring(prev.length());
        }
        if (fieldName1.length() > prev.length()) { // ���ξ� ���̸�ŭ ¥���� APPL_PERNR ==> PERNR
            fieldName1 = fieldName1.substring(prev.length());
        }

        ParameterList exportParamList = function.getExportParameterList();

        if (exportParamList.hasField(fieldName)) {
            String fieldValue = function.getExportParameterList().getString(fieldName);
            Logger.debug.println(this, "********** getField1() : " + fieldName);
            Logger.debug.println(this, "********** getField1() : " + fieldName1);

            return StringUtils.trim(fieldValue);
        }
        return null;

    }
    // dongxiaomian 20140701 end

    /**
     * RFC �����(���̺�, ��Ʈ��������) �� Table��, Vector( HashMap(�÷���, ����Ÿ) ) ) ���� ���� �����´�
     * ���� ����
     * ��Ʈ���ĸ� ȣ��� getAllExportParameter(function) ���
     * ���̺� ȣ��� getAllExportTable(function) ���
     *
     * @param function ����Ÿ�� ������ RFC function
     * @return Vector(Table��, Vector( HashMap(�÷���, ����Ÿ) ) ) ����
     * @author marco
     *         2015. 05. 21
     */
    public Vector getAllStruture(Function function) throws Exception {
        Vector ldResult = new Vector();

        ldResult.add(getAllExportParameter(function));
        ldResult.add(getAllExportTable(function));

        return ldResult;
    }

    /**
     * structure ȣ��� ����Ѵ�.
     * ��� ExportParameterList�� HashMap�������� �����´�.
     * ����� HashMap(Table��, Vector( HashMap(�÷���, ����Ÿ) ) )
     * 
     * @param function ����Ÿ�� ������ RFC function
     * @return HashMap(Table��, Vector( HashMap(�÷���, ����Ÿ) ) )
     * @author marco
     *         2015. 05. 21
     */
    public HashMap getAllExportParameter(Function function) throws Exception {
        HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Parameter ����Ÿ�� �������� �κ� */
        JCO.ParameterList pl = function.getExportParameterList();
        int nTableSize = 0;
        // null ó�� ���ش�. NullPointException�߻�
        if (pl != null)
            nTableSize = pl.getNumFields();
        for (int n = 0; n < nTableSize; n++) {
            Vector vRow = new Vector();
            HashMap<String, String> ldField = new HashMap<String, String>();
            try {
                JCO.Structure structure = pl.getStructure(n);

                int nFieldSize = structure.getFieldCount();

                for (int m = 0; m < nFieldSize; m++) {
                    com.sap.mw.jco.JCO.Field field = structure.getField(m);
                    ldField.put(field.getName(), WebUtil.nvl(field.getString()));
                }

                vRow.add(ldField);
                ldResult.put(pl.getName(n), vRow);
            } catch (JCO.ConversionException eConversion) {
                Logger.info.println(this, "eConversion error log : " + eConversion.toString());

            }
        }

        return ldResult;
    }

    /**
     * ��� Export Table�� ���� �����´�
     *
     * @param function ����Ÿ�� ������ RFC function
     * @return HashMap(Table��, Vector( HashMap(�÷���, ����Ÿ) ) ) ����
     * @throws Exception
     * @author marco
     *         2015. 05. 21
     */
    public HashMap getAllExportTable(Function function) throws Exception {
        HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Table ����Ÿ�� �������� �κ� */
        JCO.ParameterList pl = function.getTableParameterList();
        int nTableSize = 0;
        if (pl != null)
            nTableSize = pl.getFieldCount();

        // ��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for (int n = 0; n < nTableSize; n++) {
            Vector vRow = new Vector();
            JCO.Table table = pl.getTable(n);    // �ش����̺��� �����´�
            int nRow = table.getNumRows();   // ��� �ο��
            int nCol = table.getNumFields();     // ��� �÷���
            // ���̺��� ����Ÿ�� �������� �κ� Vector�� �ο�(Ldata��)�� ���ʷ� �ִ´�
            for (int i = 0; i < nRow; i++) {
                HashMap<String, String> ldCol = new HashMap<String, String>();   // �ʵ��, �� �������� �ִ´�
                for (int m = 0; m < nCol; m++) {
                    ldCol.put(table.getField(m).getName(), WebUtil.nvl(table.getField(m).getString()));
                }
                vRow.add(ldCol); // �ش�ο��� ������ ���Ϳ� ��´�
                table.nextRow(); // table Cursor�� �Ѵܰ������ �ű��.
            }
            ldResult.put(pl.getName(n), vRow);    // �ش� Table��, ���̺� �����
        }
        return ldResult;
    }

    // String sResult = "";
    //
    // Vector vMessage = (Vector) ldResult.get("E_RETURN");
    //
    // if(vMessage != null) {
    // LData ldMessage = (LData) vMessage.get(0);
    // String sType = ldMessage.getString("TYPE");
    //
    // if(!"S".equals(sType)) {
    // sResult = ldMessage.getString("MESSAGE");
    // } else sResult = "S";
    // }
    //
    // return sResult;
    // }

    /**
     * Return �Ǵ� ��� Export�Ķ���� ���� ������ �´�.
     * 
     * @param function ����Ÿ�� ������ RFC function
     * @return LData(Field��, Value)
     * @throws Exception
     * @author marco
     *         2015. 10. 06
     */
    public static HashMap<String, String> getExportParameter(Function function) throws Exception {
        HashMap<String, String> ldResult = new HashMap<String, String>();

        JCO.ParameterList pl = function.getExportParameterList();

        int nTableSize = 0;

        if (pl != null)
            nTableSize = pl.getNumFields();

        for (int n = 0; n < nTableSize; n++) {
            com.sap.mw.jco.JCO.Field field = pl.getField(n);
            ldResult.put(field.getName(), StringUtils.defaultString(field.getString()));
        }

        return ldResult;
    }
    //

    /**
     * �׽�Ʈ �̿Ϸ�
     * Ư�� Table(Structure)�� �ش��ϴ� ����� Vector(LData(�÷���, ����Ÿ)) ������ �����ش�
     * 
     * @param function ����Ÿ�� ������ RFC function
     * @param sStructureName ����Ÿ�� ������ Table(Structure) ��
     * @return Vector(LData(�÷���, ����Ÿ))
     * @throws Exception
     * @author ������
     *         2007. 08. 24
     */
    public static Vector getExportTable(Function function, String sStructureName) throws Exception {
        Vector vResult = new Vector();

        /* Export Parameter ����Ÿ�� �������� �κ� */
        JCO.ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sStructureName);  // �ش� ���̺��� �����´�

        int nRow = table.getNumRows();   // ��� �ο��
        int nCol = table.getNumFields();     // ��� �÷���

        // ���̺��� ����Ÿ�� �������� �κ� Vector�� �ο�(Ldata��)�� ���ʷ� �ִ´�
        for (int i = 0; i < nRow; i++) {

            HashMap<String, String> ldCol = new HashMap<String, String>();   // �ʵ��, �� �������� �ִ´�

            for (int m = 0; m < nCol; m++) {
                ldCol.put(table.getField(m).getName(), table.getField(m).getString());
            }

            vResult.add(ldCol); // �ش�ο��� ������ ���Ϳ� ��´�

            table.nextRow(); // table Cursor�� �Ѵܰ������ �ű��.
        }

        return vResult;
    }

    /**
     * LData�� �Ѿ�� ������ function�� �ʵ尪�� ä���
     * function�� �����ϴ� field�� �����Ͽ� ä���
     * 
     * @param function ���� ä�� function
     * @param ldParam field���� ä�� LData
     * @throws Exception
     * @author ������
     *         2007. 09. 13
     */
    public static void setFieldForLData(Function function, Box ldParam) throws Exception {
        java.util.Iterator iter = ldParam.keySet().iterator();

        ParameterList paramList = function.getImportParameterList();

        // LLog.info.println("[SAPWrapForLData] ========================================= ");

        while (iter.hasNext()) {
            String sKey = iter.next().toString();

            if (paramList.hasField(sKey)) {
                paramList.setValue(WebUtil.nvl(ldParam.getString(sKey)), sKey);
                Logger.debug("********** setField() " + sKey + " : " + ldParam.getString(sKey));
            }
        }
        // LLog.info.println("[SAPWrapForLData] ========================================= ");

    }

    /**
     * LMultiData�� �Ѿ�� ���� function table�� field�� ��� ä���
     * 
     * @param function ���� ä�� function
     * @param lMultiData field, table�� ä�� function
     * @throws Exception
     *             2007. 11. 05
     * @author ������
     */
    // public static void setAllDataForLMultiData (Function function,Box lMultiData) throws Exception {
    // EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
    // EHRSAPWrap.setTableForLMultiData(function, lMultiData);
    // }
    /**
     * LMultiData�� �Ѿ�� ���� function table�� field�� ��� ä���
     * 
     * @param function ���� ä�� function
     * @param lMultiData field, table�� ä�� function
     * @throws Exception
     *             2007. 11. 05
     * @author ������
     */
    // public static void setAllDataForLMultiData (Function function,Box lMultiData, String sLikeTableName) throws Exception {
    // EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
    // EHRSAPWrap.setTableForLMultiData(function, lMultiData, sLikeTableName);
    // }

    /**
     * Box�� �Ѿ�� ������ function �ʵ尪�� ä���
     * 
     * @param function ���� ä�� function
     * @param lMultiData field���� ä�� LMultiData
     * @throws Exception
     * @author marco257
     *         2015. 05. 21
     */
    public static void setFieldForLMultiData(Function function, Box lMultiData) throws Exception {
        // java.util.Iterator iter = ldParam.keySet().iterator();

        ParameterList paramList = function.getImportParameterList();    // function param list�� �����´�
        FieldIterator iter = paramList.fields();

        // LLog.info.println("[setFieldForLMultiData] ========================================= ");
        // field�� loop�� ���� �ش� �ʵ带 �ִ´�
        while (iter.hasNextFields()) {
            com.sap.mw.jco.JCO.Field field = iter.nextField();
            String sFieldName = field.getName();
            String sValue = "";
            if (lMultiData.containsKey(sFieldName))
                sValue = WebUtil.nvl(lMultiData.getString(sFieldName));    // field�� �Ѱ��̹Ƿ� LMultiData�� Ű�� ù��°������ �����´�

            paramList.setValue(sValue, sFieldName);
            // LLog.info..info.println("[setFieldForLMultiData] input field : " + sFieldName + " = " + sValue);
        }
        // LLog.info..info.println("[setFieldForLMultiData] ========================================= ");
    }

    /**
     * Ư�� table �� Ư�� �ʵ带 �����ؼ� insert�Ѵ�.
     * long Text �� ���
     * rfc function �� ��� ���̺� ������ ���ش�
     * 
     * @param function rfc function name
     * @param sLikeTableName �ش��̸��� �����ϴ� ���̺� ���� �Է��Ѵ�.
     * @throws Exception
     * @author marco
     *         2015. 05. 28
     */
    public static void setInsertTable(Function function, Vector vtData, String sLikeTableName, String fieldName) throws Exception {
        /* Export Table ����Ÿ�� �������� �κ� */
        HashMap<String, Object> hashtable = new HashMap<String, Object>();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); // ���̺� ũ��

        // ��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for (int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    // �ش����̺��� �����´�
            String sTableName = pl.getName(n);
            if (sTableName.indexOf(sLikeTableName) > -1) {  // ���̺���� ������ ���� �����Ѵٸ�
                int nRowSize = vtData.size(); // ���ذ��� ���̸� �������� �ο����� �ȴ�

                // //LLog.info..info.println("\n[setTableForLMultiData] Set Table [" + pl.getName(n) + "]" + sPointField + " Size " + nRowSize);
                for (int nRow = 0; nRow < nRowSize; nRow++) {
                    // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  // ���̺� row�� �߰�����
                    hashtable = (HashMap) vtData.get(nRow);
                    String sValue = WebUtil.nvl((String) hashtable.get(fieldName));
                    Logger.debug("sValue : " + sValue);
                    table.setValue(sValue, fieldName);

                }

                // ��� ���̺��� �����Ѵ�
                pl.setValue(table, pl.getName(n));
            }
        }
        //// LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * Ư�� Table�� insert�Ѵ�.
     * 
     * @param function
     * @param vtData
     * @param sLikeTableName
     * @throws Exception
     */
    public static void setTableForLMultiData(Function function, Vector vtData, String sLikeTableName) throws Exception {
        /* Export Table ����Ÿ�� �������� �κ� */
        HashMap<String, Object> hashtable = new HashMap<String, Object>();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); // ���̺� ũ��

        // ��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for (int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    // �ش����̺��� �����´�
            String sTableName = pl.getName(n);
            if (sTableName.indexOf(sLikeTableName) > -1) {  // ���̺���� ������ ���� �����Ѵٸ�
                int nRowSize = vtData.size(); // ���ذ��� ���̸� �������� �ο����� �ȴ�

                // //LLog.info..info.println("\n[setTableForLMultiData] Set Table [" + pl.getName(n) + "]" + sPointField + " Size " + nRowSize);
                for (int nRow = 0; nRow < nRowSize; nRow++) {
                    // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  // ���̺� row�� �߰�����
                    hashtable = (HashMap) vtData.get(nRow);

                    FieldIterator iter = table.fields();
                    while (iter.hasNextFields()) {
                        com.sap.mw.jco.JCO.Field field = iter.nextField();
                        String sFieldName = field.getName();
                        String sValue = "";

                        if (hashtable.containsKey(sFieldName))
                            sValue = WebUtil.nvl((String) hashtable.get(sFieldName));

                        /*
                         * table�� �ʵ忡 �ش��ϴ� ���� ��������
                         * null ���� �����Ѵ�
                         */
                        table.setValue(sValue, sFieldName);
                        // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
                    }
                }
            }

            // ��� ���̺��� �����Ѵ�
            pl.setValue(table, pl.getName(n));

        }
        //// LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * JDF���� �����ϴ� Box�� jco�� �̿��Ͽ� ���̺� insert�� �ش�
     * rfc function �� ��� ���̺� ������ ���ش�
     * 
     * @param function rfc function name
     * @param lMultiData request�� �Ѿ�� LMulitData
     * @throws Exception
     * @author marco257
     *         2015. 05.28
     */
    // public static void setTableForLMultiData(Function function,Box box) throws Exception {
    // /* Export Table ����Ÿ�� �������� �κ� */
    // ParameterList pl = function.getTableParameterList();
    // int nTableSize = pl.getFieldCount(); //���̺� ũ��
    //
    // // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    //
    // //��� ���̺� �� ��ŭ ������ ���� ����� ��������
    // for(int n = 0; n < nTableSize; n++) {
    //
    // Table table = pl.getTable(n); //�ش����̺��� �����´�
    //
    // String sPointField = table.getField(0).getName(); //���̺��� ù��° �ʵ带 ���ذ����� �Ѵ�
    // int nRowSize = box.gets(sPointField); //���ذ��� ���̸� �������� �ο����� �ȴ�
    //
    // // //LLog.info..info.println("\n[setTableForLMultiData] Set Table [" + pl.getName(n) + "] Size " + nRowSize);
    // for(int nRow = 0; nRow < nRowSize; nRow++) {
    // ////LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
    // table.appendRow(); //���̺� row�� �߰�����
    //
    // FieldIterator iter = table.fields();
    //
    // while(iter.hasNextFields()){
    // com.sap.mw.jco.JCO.Field field = iter.nextField();
    // String sFieldName = field.getName();
    // String sValue = "";
    //
    // if(lMultiData.containsKey(sFieldName))
    // sValue = WebUtil.nvl(lMultiData.getString(sFieldName, nRow));
    //
    // /*
    // * table�� �ʵ忡 �ش��ϴ� ���� ��������
    // * null ���� �����Ѵ�
    // */
    // table.setValue(sValue, sFieldName);
    // // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
    // }
    // }
    //
    // //��� ���̺��� �����Ѵ�
    // pl.setValue(table, pl.getName(n));
    // }
    // // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    // }

    /**
     * R3�� table�ȿ� ���Ե� structure�� �ƴ� import�Ķ������ structure ����
     * Changing ������ ����
     * 
     * @param function
     * @param lMultiData
     * @throws Exception
     *             marco257
     *             2015. 05. 29
     */
    public static void setImportStructureMultiData(Function function, Box lMultiData, String struName) throws Exception {

        ParameterList pl = function.getImportParameterList();
        JCO.Structure structure = pl.getStructure(struName);
        int nTableSize = structure.getFieldCount(); // ���̺� ũ��

        // ��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for (int n = 0; n < nTableSize; n++) {
            String sFieldName = structure.getField(n).getName();

            if (lMultiData.containsKey(sFieldName)) {
                structure.setValue(WebUtil.nvl(lMultiData.getString(sFieldName)), sFieldName);
            }
        }
        function.getImportParameterList().setValue(structure, struName);
    }

    /**
     * LData�� �ִ� ������ �ش� Ŭ������ ä�� �Ѱ��ش�
     * param������ �Ѿ�� LData�� ������ �����ؼ� �Ѿ�� Ŭ������ ����Ÿ ���� �Է� ��
     * �ش� Class�� �Ѱ��ش�
     * 
     * @param ldParam EntityClass�� ������ LData
     * @param sClassName ����� �Ѱܹ��� Class
     * @return
     * @author ������
     *         2007. 09. 07
     */
    public static Object getLDataToClass(Box ldParam, String sClassName) throws Exception {
        Object obj = null;

        try {
            Class klass = Class.forName(sClassName);    // �ش� Ŭ������������
            obj = klass.newInstance();                            // ��ü ����
            Field[] fields = klass.getFields();                    // �ش� Ŭ�������� �ʵ尡������

            for (int n = 0; n < fields.length; n++) {
                Field field = fields[n];
                String sValue = ldParam.getString(field.getName());

                // ���� LData�� �ش� ���� �������� ������ �ʵ尪�� ü���� �ʴ´�
                if (!"".equals(WebUtil.nvl(sValue)))
                    field.set(obj, sValue);
            }
        } catch (Exception e) {
            // LLog.info..err.println("[ SAPWrapForLData.getLDataToClass ERROR ] Class �ۼ��� ���� : Ŭ������ Ȯ��");
            throw new Exception(e);
        }

        return obj;
    }

    /**
     * LData�� �ִ� ������ �ش� Ŭ������ ä�� �Ѱ��ش�
     * param������ �Ѿ�� LData�� ������ �����ؼ� �Ѿ�� Ŭ������ ����Ÿ ���� �Է� ��
     * Ŭ������ ���� ��ü�� �����Ͽ� Vector(��ü�迭)�� �Ѱ��ش�
     * ldParam���� �ִ� ���� �ش� Ŭ�������� �ʵ忡 �����Ѵ�
     * 
     * @param ldParam EntityClass�� ������ LData
     * @param vClassName ����� �Ѱܹ��� Class�迭 �ߺ��� Ŭ�������� �Ѱ��� ��ȯ�ȴ�
     * @return sClassName�� �ش��ϴ� ��ü Map
     * @throws Exception
     * @author ������
     *         2007. 09. 07
     */
    // public static LData getLDataToClasses(Box ldParam, Vector vClassName) throws Exception {
    // HashMap<String, String> ldResult = new HashMap<String, String>(); //�����
    //
    // for(int n = 0; n < vClassName.size(); n++) {
    // try { //�߰� Ŭ������ �����ص� ����� �Ѱ��ش�
    // ldResult.put(vClassName.get(n), getLDataToClass(ldParam, vClassName.get(n).toString()));
    // }catch(Exception e){
    //// //LLog.info..err.println(e.getMessage());
    // }
    // }
    //
    // return ldResult;
    // }

    /**
     * sap�� raw�� ����� file download
     * 
     * @param function function
     * @param sTableName table��
     * @param sFieldName raw�� ������ �ʵ��
     * @param sFilePath ���� ������(���ϸ� ����) ex( c:\\test.txt)
     * @return ����� ���� ��� req�� �Ѿ�� sFilePath ���н� ""
     * @author ������
     *         2007. 12. 07
     */
    public static String downFileFromSap(Function function, String sTableName, String sFieldName, String sFilePath) {
        String sResult = sFilePath;
        //// LLog.info..debug.println("sFilePath : " + sFilePath);
        ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sTableName);    // �ش����̺��� �����´�

        int nRow = table.getNumRows();         // ��� �ο��
        // int nCol = table.getNumFields(); //��� �÷���
        File file = null;

        BufferedInputStream bin = null;     // BufferedInputStream
        BufferedOutputStream bout = null;   // BufferedOutputStream
        try {

            // ��ΰ� ���� ��� ����
            String sDir = "";
            try {
                sDir = sFilePath.substring(0, sFilePath.lastIndexOf("\\"));
            } catch (Exception e) {
                sDir = sFilePath.substring(0, sFilePath.lastIndexOf("/"));
            }

            File fDir = new File(sDir);

            // �������� 1�� ����
            if (!fDir.getAbsolutePath().equals(fDir.getCanonicalPath())) {
                try {
                    throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
                } catch (Exception e) {
                    Logger.debug.println(e.getMessage());
                }
            }
            //// LLog.info..debug.println("[SAPWrapForLData] sFilePath : " + sFilePath + " read : " + fDir.canRead() + " write : " + fDir.canWrite());
            fDir.mkdirs();

            file = new File(sFilePath);

            // �������� 1�� ����
            if (!file.getAbsolutePath().equals(file.getCanonicalPath())) {
                try {
                    throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
                } catch (Exception e) {
                    Logger.debug.println(e.getMessage());
                }
            }

            bout = new BufferedOutputStream(new FileOutputStream(file));

            // ���̺��� ����Ÿ�� �������� �κ� Vector�� �ο�(Ldata��)�� ���ʷ� �ִ´�
            for (int i = 0; i < nRow; i++) {
                com.sap.mw.jco.JCO.Field field = table.getField(sFieldName);

                bin = new BufferedInputStream(field.getBinaryStream());

                int n = 0;
                while ((n = bin.read()) > -1) {
                    // sb.append(n);
                    bout.write(n);
                }

                bin.close();

                table.nextRow(); // table Cursor�� �Ѵܰ������ �ű��.
            }

        } catch (Exception e) {
            sResult = "";

            if (file.exists()) {
                file.delete();
            }

            //// LLog.info..debug.println("[ SAPWrapForLData.downFileFromSap ERROR ] FILE Download Fail \n" + e.getMessage());
        } finally {
            if (bout != null) {
                try {
                    bout.close();
                } catch (Exception ex) {
                }
            }
            if (bin != null) {
                try {
                    bin.close();
                } catch (Exception ex) {
                }
            }
        }

        return sResult;
    }

    public RFCReturnEntity getReturn() {
        return (RFCReturnEntity) ObjectUtils.defaultIfNull(rfcReturnEntity, new RFCReturnEntity());
    }

    /**
     * getAllStructure�� ������ ��ü ����Ÿ �� �޼��� ó��
     * 
     * @param ldResult �����ϰ�� S, �����ϰ�� ���и޼���
     * @return
     * @author marco257
     *         2015. 05. 21
     */
    // public static String getReturnMessage(Vector ldResult) {
    // String sResult = "";
    //
    // HashMap vMessage = (HashMap) ldResult.("RETURN");
    //
    // if(vMessage != null) {
    // LData ldMessage = (LData) vMessage.get(0);
    // String sType = ldMessage.getString("TYPE");
    //
    // if(!"S".equals(sType)) {
    // sResult = ldMessage.getString("MESSAGE");
    // } else sResult = "S";
    // }
    //
    // return sResult;
    // }

    /**
     * getAllStructure�� ������ ��ü ����Ÿ �� �޼��� ó��
     * 
     * @param ldResult �����ϰ�� S, �����ϰ�� ���и޼���
     * @return
     * @author ������
     *         2007. 12. 20
     */
    // public static String getEReturnEMessage(LData ldResult) {
    // String sResult = "";
    //
    // Vector vMessage = (Vector) ldResult.get("E_RETURN");
    //
    // if(vMessage != null) {
    // LData ldMessage = (LData) vMessage.get(0);
    // String sType = ldMessage.getString("TYPE");
    //
    // if(!"S".equals(sType)) {
    // sResult = ldMessage.getString("MESSAGE");
    // } else sResult = "S";
    // }
    //
    // return sResult;
    // }
}
