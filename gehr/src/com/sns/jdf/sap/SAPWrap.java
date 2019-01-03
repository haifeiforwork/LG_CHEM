/********************************************************************************/
/*   Program ID   : SAPWrap.java                                                */
/*   Description  :                                                             */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       :   [CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정    2017-06-15 eunha */
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

    private SAPType sapType;	// 기본값은 국내SAPType.LOCAL;

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
        if (flag.equals("x")) { // connection이 추가되는경우
            connectMap.get(sapType).SAP_COUNT = connectMap.get(sapType).SAP_COUNT + 1;
        } else {// connection이 종료되는경우
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
            // [CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 2017-06-15 eunha start
            WebUserData userLoginData = WebUtil.getSessionUser(((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());

            if (userLoginData != null) {
                if (userLoginData.e_authorization.indexOf("H") > -1)
                    setField(function, "I_SFLAG", "Y");
                else
                    setField(function, "I_SFLAG", "");
            }
            // [CSR ID:3413389] 호칭변경(직위/직급)에 따른 인사 화면 수정 2017-06-15 eunha end

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
                Logger.err.println(this, "------ E_RETURN structure 없음 계속 진행");
            }

        } catch (Exception ex) {
            Logger.sap.println(this, "excute를 할수 없습니다." + ex.toString());
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

    // 한글/영문 컨버젼
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
    // setTable : 아직 쓰지 말것...
    public void setTable(Function function, String tableName, Vector entityVector) throws GeneralException {
        setTable(function, tableName, entityVector, "");
    }

    // setStructor : 아직 쓰지 말것...
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
    // 값을 trim() 하지 않고 반환함;
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
     * 근로소득 원천징수 영수증 PDF Data처리를 위해 추가된 함수
     * [CSR : C20100427_56011] 근로소득원천징수영수증/갑근세원천징수증명서 PDF전환 요청 김세미 2010.04.28
     * [C20100510_63186] ESS 급여조정 내용 수정 : 원천징수 추가 변경 (2010.05.17 김세미)
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
            Logger.debug.println(this, "getHashMapTable() 에서 예외발생 " + ex.toString());
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
            Logger.debug.println(this, "getCodeVector( Function function, String tableName)에서 예외발생 ");
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
            Logger.debug.println(this, "getCodeVector( Function function, String tableName, String codeField, String valueField )에서 예외발생 ");
            throw new GeneralException(ex);
        }
        return retvt;
    }

    /*
     *  필드명에 접두어가 붙어서 필드명이 서로 다를경우 메칭하는 메소드...
     *  ex) XxxData.APPL_PERNR       ===>    Function의 PERNR
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
                    if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "setTable(Function function, String tableName, Vector entityVector)에서 예외발생 ");
            Logger.debug.println(this, ex.toString());
            throw new GeneralException(ex);
        }
    }

    // setStructor : 아직 쓰지 말것...
    public void setStructor(Function function, String structureName, Object data, String prev) throws GeneralException {
        try {
            JCO.Structure structure = function.getImportParameterList().getStructure(structureName);

            DataUtil.fixNull(data);
            Class c = data.getClass();
            Field[] fields = c.getFields();

            for (int k = 0; k < fields.length; k++) {
                String fieldName = fields[k].getName();
                if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "getStructor(Object data, Function function, String structureName)에서 예외발생 ");
            Logger.info.println(this, "원인 찾자 rdcamel1 : " + ex.toString());
            throw new GeneralException(ex);
        }
    }

    /**
     * data frield값에 I_ 붙인 필드명의 값을 가져온다
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
                if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
                    fieldName = fieldName.substring(prev.length());
                }
                fieldName = "I_" + fieldName;
                if (function.getImportParameterList().hasField(fieldName)) {
                    function.getImportParameterList().setValue((String) fields[k].get(data), fieldName);
                }
            }

            Logger.debug.println(this, "********** setFields() " + data.toString());
        } catch (Exception ex) {
            Logger.debug.println(this, "setFields(Function function, Object data))에서 예외발생 ");
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
                if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
                    fieldName = fieldName.substring(prev.length());
                }

                // && fields[k].get(data) != null 추가 함 null일 경우 기본값 "" 값은 들어감:기본값 무시됨
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
            Logger.debug.println(this, "setFields(Function function, Object data))에서 예외발생 ");
            throw new GeneralException(ex);
        }
    }

    public void setField(Function function, String fieldName, String value, String prev) throws GeneralException {
        try {
            if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "setField(Function function, String fieldName, String value)에서 예외발생 ");
            throw new GeneralException(ex);
        }
    }

    // dongxiaomian 20140701 begin
    protected void setField1(JCO.Function function, String fieldName, String value, String prev, String fieldName1, String value1) throws GeneralException {
        try {
            if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "setField1(JCO.Function function, String fieldName, String value)에서 예외발생 ");
            throw new GeneralException(ex);
        }
    }
    // dongxiaomian 20140701 end

    ////////////////////////////////////////

    // 값을 trim() 하지 않고 반환함;
    public Vector getTableNoTrim(String entityName, Function function, String tableName, String prev) throws GeneralException {
        Vector retvt = new Vector();
        try {
            JCO.Table table = function.getTableParameterList().getTable(tableName);
            // Logger.debug.println(this, "[]Package 경로가 잡혀있어야함 : "+entityName);
            Class c = Class.forName(entityName);
            Object data = null;
            Field[] fields = c.getFields();
            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);
                data = c.newInstance();
                for (int k = 0; k < fields.length; k++) {
                    String fieldName = fields[k].getName();
                    if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "getTable(String entityName, Function function, String functionName)에서 예외발생 ");
            Logger.debug.println(this, "entityName는 Package 경로가 잡혀있어야함 .. 확인요 ");
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
            // Logger.debug.println(this, "[]Package 경로가 잡혀있어야함 : "+entityName);
            Object data = null;
            Field[] fields = entityClass.getFields();
            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);
                data = entityClass.newInstance();
                for (int k = 0; k < fields.length; k++) {
                    try {
                        String fieldName = fields[k].getName();
                        if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "getTable(String entityName, Function function, String functionName)에서 예외발생 ");
            Logger.debug.println(this, "entityName는 Package 경로가 잡혀있어야함 .. 확인요 ");
            throw new GeneralException(ex);
        }
        return retvt;
    }

    /**
     * prev + data의 필드명 의 값을 가져온다
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
            Logger.debug.println(this, "getStructor(Object data, Function function, String structureName)에서 예외발생 ");
            Logger.info.println(this, "원인 찾자 rdcamel2 : " + ex.toString());
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
                if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "getFields(Object data, Function function)에서 예외발생 ");
            throw new GeneralException(ex);
        }
        return data;
    }

    /**
     * entity값에 E_ 값을 붙은 필드들을 가져온다
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
     * entity값에 E_ 값을 붙은 필드들을 가져온다
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
                if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
            Logger.debug.println(this, "getFields(Object data, Function function)에서 예외발생 ");
            throw new GeneralException(ex);
        }
        return data;
    }

    public String getField(String fieldName, Function function, String prev) throws GeneralException {
        if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
        if (fieldName.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
            fieldName = fieldName.substring(prev.length());
        }
        if (fieldName1.length() > prev.length()) { // 접두어 길이만큼 짜르자 APPL_PERNR ==> PERNR
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
     * RFC 모든결과(테이블, 스트럭쳐포함) 를 Table명, Vector( HashMap(컬럼명, 데이타) ) ) 형식 으로 가져온다
     * 참고 사항
     * 스트럭쳐만 호출시 getAllExportParameter(function) 사용
     * 테이블 호출시 getAllExportTable(function) 사용
     *
     * @param function 데이타를 가져오 RFC function
     * @return Vector(Table명, Vector( HashMap(컬럼명, 데이타) ) ) 형식
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
     * structure 호출시 사용한다.
     * 모드 ExportParameterList를 HashMap형식으로 가져온다.
     * 결과는 HashMap(Table명, Vector( HashMap(컬럼명, 데이타) ) )
     * 
     * @param function 데이타를 가져오 RFC function
     * @return HashMap(Table명, Vector( HashMap(컬럼명, 데이타) ) )
     * @author marco
     *         2015. 05. 21
     */
    public HashMap getAllExportParameter(Function function) throws Exception {
        HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Parameter 데이타를 가져오는 부분 */
        JCO.ParameterList pl = function.getExportParameterList();
        int nTableSize = 0;
        // null 처리 해준다. NullPointException발생
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
     * 모든 Export Table의 값을 가져온다
     *
     * @param function 데이타를 가져오 RFC function
     * @return HashMap(Table명, Vector( HashMap(컬럼명, 데이타) ) ) 형식
     * @throws Exception
     * @author marco
     *         2015. 05. 21
     */
    public HashMap getAllExportTable(Function function) throws Exception {
        HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Table 데이타를 가져오는 부분 */
        JCO.ParameterList pl = function.getTableParameterList();
        int nTableSize = 0;
        if (pl != null)
            nTableSize = pl.getFieldCount();

        // 결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for (int n = 0; n < nTableSize; n++) {
            Vector vRow = new Vector();
            JCO.Table table = pl.getTable(n);    // 해당테이블을 가져온다
            int nRow = table.getNumRows();   // 결과 로우수
            int nCol = table.getNumFields();     // 결과 컬럼수
            // 테이블에서 데이타를 가져오는 부분 Vector에 로우(Ldata형)를 차례로 넣는다
            for (int i = 0; i < nRow; i++) {
                HashMap<String, String> ldCol = new HashMap<String, String>();   // 필드명, 값 형식으로 넣는다
                for (int m = 0; m < nCol; m++) {
                    ldCol.put(table.getField(m).getName(), WebUtil.nvl(table.getField(m).getString()));
                }
                vRow.add(ldCol); // 해당로우의 값들을 벡터에 담는다
                table.nextRow(); // table Cursor를 한단계앞으로 옮긴다.
            }
            ldResult.put(pl.getName(n), vRow);    // 해당 Table명, 테이블 결과값
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
     * Return 되는 모든 Export파라미터 값을 가지고 온다.
     * 
     * @param function 데이타를 가져오 RFC function
     * @return LData(Field명, Value)
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
     * 테스트 미완료
     * 특정 Table(Structure)에 해당하는 결과를 Vector(LData(컬럼명, 데이타)) 형으로 돌려준다
     * 
     * @param function 데이타를 가져오 RFC function
     * @param sStructureName 데이타를 가져올 Table(Structure) 명
     * @return Vector(LData(컬럼명, 데이타))
     * @throws Exception
     * @author 정진만
     *         2007. 08. 24
     */
    public static Vector getExportTable(Function function, String sStructureName) throws Exception {
        Vector vResult = new Vector();

        /* Export Parameter 데이타를 가져오는 부분 */
        JCO.ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sStructureName);  // 해당 테이블을 가져온다

        int nRow = table.getNumRows();   // 결과 로우수
        int nCol = table.getNumFields();     // 결과 컬럼수

        // 테이블에서 데이타를 가져오는 부분 Vector에 로우(Ldata형)를 차례로 넣는다
        for (int i = 0; i < nRow; i++) {

            HashMap<String, String> ldCol = new HashMap<String, String>();   // 필드명, 값 형식으로 넣는다

            for (int m = 0; m < nCol; m++) {
                ldCol.put(table.getField(m).getName(), table.getField(m).getString());
            }

            vResult.add(ldCol); // 해당로우의 값들을 벡터에 담는다

            table.nextRow(); // table Cursor를 한단계앞으로 옮긴다.
        }

        return vResult;
    }

    /**
     * LData로 넘어온 값들을 function의 필드값에 채운다
     * function에 존재하는 field만 선택하여 채운다
     * 
     * @param function 값을 채울 function
     * @param ldParam field값을 채울 LData
     * @throws Exception
     * @author 정진만
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
     * LMultiData로 넘어온 값들 function table과 field에 모두 채운다
     * 
     * @param function 값을 채울 function
     * @param lMultiData field, table을 채울 function
     * @throws Exception
     *             2007. 11. 05
     * @author 정진만
     */
    // public static void setAllDataForLMultiData (Function function,Box lMultiData) throws Exception {
    // EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
    // EHRSAPWrap.setTableForLMultiData(function, lMultiData);
    // }
    /**
     * LMultiData로 넘어온 값들 function table과 field에 모두 채운다
     * 
     * @param function 값을 채울 function
     * @param lMultiData field, table을 채울 function
     * @throws Exception
     *             2007. 11. 05
     * @author 정진만
     */
    // public static void setAllDataForLMultiData (Function function,Box lMultiData, String sLikeTableName) throws Exception {
    // EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
    // EHRSAPWrap.setTableForLMultiData(function, lMultiData, sLikeTableName);
    // }

    /**
     * Box로 넘어온 값들을 function 필드값에 채운다
     * 
     * @param function 값을 채울 function
     * @param lMultiData field값을 채울 LMultiData
     * @throws Exception
     * @author marco257
     *         2015. 05. 21
     */
    public static void setFieldForLMultiData(Function function, Box lMultiData) throws Exception {
        // java.util.Iterator iter = ldParam.keySet().iterator();

        ParameterList paramList = function.getImportParameterList();    // function param list를 가져온다
        FieldIterator iter = paramList.fields();

        // LLog.info.println("[setFieldForLMultiData] ========================================= ");
        // field를 loop를 돌아 해당 필드를 넣는다
        while (iter.hasNextFields()) {
            com.sap.mw.jco.JCO.Field field = iter.nextField();
            String sFieldName = field.getName();
            String sValue = "";
            if (lMultiData.containsKey(sFieldName))
                sValue = WebUtil.nvl(lMultiData.getString(sFieldName));    // field는 한개이므로 LMultiData의 키중 첫번째값만을 가져온다

            paramList.setValue(sValue, sFieldName);
            // LLog.info..info.println("[setFieldForLMultiData] input field : " + sFieldName + " = " + sValue);
        }
        // LLog.info..info.println("[setFieldForLMultiData] ========================================= ");
    }

    /**
     * 특정 table 에 특정 필드를 지정해서 insert한다.
     * long Text 시 사용
     * rfc function 에 모든 테이블에 셋팅을 해준다
     * 
     * @param function rfc function name
     * @param sLikeTableName 해당이름을 포함하는 테이블 만을 입력한다.
     * @throws Exception
     * @author marco
     *         2015. 05. 28
     */
    public static void setInsertTable(Function function, Vector vtData, String sLikeTableName, String fieldName) throws Exception {
        /* Export Table 데이타를 가져오는 부분 */
        HashMap<String, Object> hashtable = new HashMap<String, Object>();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); // 테이블 크기

        // 결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for (int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    // 해당테이블을 가져온다
            String sTableName = pl.getName(n);
            if (sTableName.indexOf(sLikeTableName) > -1) {  // 테이블명을 포함한 값이 존재한다면
                int nRowSize = vtData.size(); // 기준값의 길이를 가져오자 로우사이즈가 된다

                // //LLog.info..info.println("\n[setTableForLMultiData] Set Table [" + pl.getName(n) + "]" + sPointField + " Size " + nRowSize);
                for (int nRow = 0; nRow < nRowSize; nRow++) {
                    // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  // 테이블 row를 추가하자
                    hashtable = (HashMap) vtData.get(nRow);
                    String sValue = WebUtil.nvl((String) hashtable.get(fieldName));
                    Logger.debug("sValue : " + sValue);
                    table.setValue(sValue, fieldName);

                }

                // 결과 테이블을 셋팅한다
                pl.setValue(table, pl.getName(n));
            }
        }
        //// LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * 특정 Table에 insert한다.
     * 
     * @param function
     * @param vtData
     * @param sLikeTableName
     * @throws Exception
     */
    public static void setTableForLMultiData(Function function, Vector vtData, String sLikeTableName) throws Exception {
        /* Export Table 데이타를 가져오는 부분 */
        HashMap<String, Object> hashtable = new HashMap<String, Object>();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); // 테이블 크기

        // 결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for (int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    // 해당테이블을 가져온다
            String sTableName = pl.getName(n);
            if (sTableName.indexOf(sLikeTableName) > -1) {  // 테이블명을 포함한 값이 존재한다면
                int nRowSize = vtData.size(); // 기준값의 길이를 가져오자 로우사이즈가 된다

                // //LLog.info..info.println("\n[setTableForLMultiData] Set Table [" + pl.getName(n) + "]" + sPointField + " Size " + nRowSize);
                for (int nRow = 0; nRow < nRowSize; nRow++) {
                    // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  // 테이블 row를 추가하자
                    hashtable = (HashMap) vtData.get(nRow);

                    FieldIterator iter = table.fields();
                    while (iter.hasNextFields()) {
                        com.sap.mw.jco.JCO.Field field = iter.nextField();
                        String sFieldName = field.getName();
                        String sValue = "";

                        if (hashtable.containsKey(sFieldName))
                            sValue = WebUtil.nvl((String) hashtable.get(sFieldName));

                        /*
                         * table에 필드에 해당하는 값을 셋팅하자
                         * null 값은 제거한다
                         */
                        table.setValue(sValue, sFieldName);
                        // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
                    }
                }
            }

            // 결과 테이블을 셋팅한다
            pl.setValue(table, pl.getName(n));

        }
        //// LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * JDF에서 제공하는 Box와 jco를 이용하여 테이블에 insert해 준다
     * rfc function 에 모든 테이블에 셋팅을 해준다
     * 
     * @param function rfc function name
     * @param lMultiData request로 넘어온 LMulitData
     * @throws Exception
     * @author marco257
     *         2015. 05.28
     */
    // public static void setTableForLMultiData(Function function,Box box) throws Exception {
    // /* Export Table 데이타를 가져오는 부분 */
    // ParameterList pl = function.getTableParameterList();
    // int nTableSize = pl.getFieldCount(); //테이블 크기
    //
    // // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    //
    // //결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
    // for(int n = 0; n < nTableSize; n++) {
    //
    // Table table = pl.getTable(n); //해당테이블을 가져온다
    //
    // String sPointField = table.getField(0).getName(); //테이블의 첫번째 필드를 기준값으로 한다
    // int nRowSize = box.gets(sPointField); //기준값의 길이를 가져오자 로우사이즈가 된다
    //
    // // //LLog.info..info.println("\n[setTableForLMultiData] Set Table [" + pl.getName(n) + "] Size " + nRowSize);
    // for(int nRow = 0; nRow < nRowSize; nRow++) {
    // ////LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
    // table.appendRow(); //테이블 row를 추가하자
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
    // * table에 필드에 해당하는 값을 셋팅하자
    // * null 값은 제거한다
    // */
    // table.setValue(sValue, sFieldName);
    // // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
    // }
    // }
    //
    // //결과 테이블을 셋팅한다
    // pl.setValue(table, pl.getName(n));
    // }
    // // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    // }

    /**
     * R3의 table안에 포함된 structure가 아닌 import파라미터의 structure 셋팅
     * Changing 구조에 적용
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
        int nTableSize = structure.getFieldCount(); // 테이블 크기

        // 결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for (int n = 0; n < nTableSize; n++) {
            String sFieldName = structure.getField(n).getName();

            if (lMultiData.containsKey(sFieldName)) {
                structure.setValue(WebUtil.nvl(lMultiData.getString(sFieldName)), sFieldName);
            }
        }
        function.getImportParameterList().setValue(structure, struName);
    }

    /**
     * LData에 있는 값들을 해당 클래스에 채워 넘겨준다
     * param값으로 넘어온 LData의 값들을 추출해서 넘어온 클래스의 데이타 값에 입력 후
     * 해당 Class로 넘겨준다
     * 
     * @param ldParam EntityClass로 변경할 LData
     * @param sClassName 결과로 넘겨받을 Class
     * @return
     * @author 정진만
     *         2007. 09. 07
     */
    public static Object getLDataToClass(Box ldParam, String sClassName) throws Exception {
        Object obj = null;

        try {
            Class klass = Class.forName(sClassName);    // 해당 클래스가져오기
            obj = klass.newInstance();                            // 개체 생성
            Field[] fields = klass.getFields();                    // 해당 클래스에서 필드가져오기

            for (int n = 0; n < fields.length; n++) {
                Field field = fields[n];
                String sValue = ldParam.getString(field.getName());

                // 만약 LData에 해당 값이 존재하지 않으면 필드값을 체우지 않는다
                if (!"".equals(WebUtil.nvl(sValue)))
                    field.set(obj, sValue);
            }
        } catch (Exception e) {
            // LLog.info..err.println("[ SAPWrapForLData.getLDataToClass ERROR ] Class 작성중 에러 : 클래스명 확인");
            throw new Exception(e);
        }

        return obj;
    }

    /**
     * LData에 있는 값들을 해당 클래스에 채워 넘겨준다
     * param값으로 넘어온 LData의 값들을 추출해서 넘어온 클래스의 데이타 값에 입력 후
     * 클래스명에 대한 개체를 생성하여 Vector(개체배열)로 넘겨준다
     * ldParam값에 있는 값을 해당 클래스들의 필드에 셋팅한다
     * 
     * @param ldParam EntityClass로 변경할 LData
     * @param vClassName 결과로 넘겨받을 Class배열 중복된 클래스명은 한개만 반환된다
     * @return sClassName에 해당하는 개체 Map
     * @throws Exception
     * @author 정진만
     *         2007. 09. 07
     */
    // public static LData getLDataToClasses(Box ldParam, Vector vClassName) throws Exception {
    // HashMap<String, String> ldResult = new HashMap<String, String>(); //결과값
    //
    // for(int n = 0; n < vClassName.size(); n++) {
    // try { //중간 클래스가 실패해도 결과를 넘겨준다
    // ldResult.put(vClassName.get(n), getLDataToClass(ldParam, vClassName.get(n).toString()));
    // }catch(Exception e){
    //// //LLog.info..err.println(e.getMessage());
    // }
    // }
    //
    // return ldResult;
    // }

    /**
     * sap의 raw에 저장된 file download
     * 
     * @param function function
     * @param sTableName table명
     * @param sFieldName raw로 지정된 필드명
     * @param sFilePath 파일 절대경로(파일명 포함) ex( c:\\test.txt)
     * @return 저장된 파일 경로 req로 넘어온 sFilePath 실패시 ""
     * @author 정진만
     *         2007. 12. 07
     */
    public static String downFileFromSap(Function function, String sTableName, String sFieldName, String sFilePath) {
        String sResult = sFilePath;
        //// LLog.info..debug.println("sFilePath : " + sFilePath);
        ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sTableName);    // 해당테이블을 가져온다

        int nRow = table.getNumRows();         // 결과 로우수
        // int nCol = table.getNumFields(); //결과 컬럼수
        File file = null;

        BufferedInputStream bin = null;     // BufferedInputStream
        BufferedOutputStream bout = null;   // BufferedOutputStream
        try {

            // 경로가 없을 경우 생성
            String sDir = "";
            try {
                sDir = sFilePath.substring(0, sFilePath.lastIndexOf("\\"));
            } catch (Exception e) {
                sDir = sFilePath.substring(0, sFilePath.lastIndexOf("/"));
            }

            File fDir = new File(sDir);

            // 보안진단 1차 개선
            if (!fDir.getAbsolutePath().equals(fDir.getCanonicalPath())) {
                try {
                    throw new Exception("파일경로 및 파일명을 확인하십시오.");
                } catch (Exception e) {
                    Logger.debug.println(e.getMessage());
                }
            }
            //// LLog.info..debug.println("[SAPWrapForLData] sFilePath : " + sFilePath + " read : " + fDir.canRead() + " write : " + fDir.canWrite());
            fDir.mkdirs();

            file = new File(sFilePath);

            // 보안진단 1차 개선
            if (!file.getAbsolutePath().equals(file.getCanonicalPath())) {
                try {
                    throw new Exception("파일경로 및 파일명을 확인하십시오.");
                } catch (Exception e) {
                    Logger.debug.println(e.getMessage());
                }
            }

            bout = new BufferedOutputStream(new FileOutputStream(file));

            // 테이블에서 데이타를 가져오는 부분 Vector에 로우(Ldata형)를 차례로 넣는다
            for (int i = 0; i < nRow; i++) {
                com.sap.mw.jco.JCO.Field field = table.getField(sFieldName);

                bin = new BufferedInputStream(field.getBinaryStream());

                int n = 0;
                while ((n = bin.read()) > -1) {
                    // sb.append(n);
                    bout.write(n);
                }

                bin.close();

                table.nextRow(); // table Cursor를 한단계앞으로 옮긴다.
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
     * getAllStructure로 가져온 전체 데이타 중 메세지 처리
     * 
     * @param ldResult 성공일경우 S, 실패일경우 실패메세지
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
     * getAllStructure로 가져온 전체 데이타 중 메세지 처리
     * 
     * @param ldResult 성공일경우 S, 실패일경우 실패메세지
     * @return
     * @author 정진만
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
