package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * AppListRFC.java
 * �������� List �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���   
 * @version 1.0, 2002/01/14
 */
public class C02CurriInfoListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_INFORMATION";

    /**
     * �������� List �� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.Object hris.C.C02Curri.C02CurriInfoData Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCurriInfoList( Object key ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, key);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            String newDate = WebUtil.printDate( DataUtil.getCurrentDate(), "-" );
            Logger.debug.println( this, "newDate : "+newDate );
            for ( int i = 0 ; i < ret.size() ; i++ ){
                C02CurriInfoData data = (C02CurriInfoData)ret.get(i);
                if( data.SDATE.equals("0000-00-00")||data.SDATE.equals("") ){
                    if( (data.BEGDA).compareTo(newDate) > 0 ){
                        data.STATE="������";
                    } else if( (data.BEGDA).compareTo(newDate) <= 0 && (data.ENDDA).compareTo(newDate) >= 0 ){
                        data.STATE="�ǽ���";
                    } else {
                        data.STATE="����";
                    }
                } else {
                    if( (data.SDATE).compareTo(newDate) > 0 ){
                        data.STATE="������";
                    } else if( (data.EDATE).compareTo(newDate) < 0 && (data.BEGDA).compareTo(newDate) > 0 ){
                        data.STATE="�����Ϸ�";
                    } else if( (data.BEGDA).compareTo(newDate) <= 0 && (data.ENDDA).compareTo(newDate) >= 0 ){
                        data.STATE="�ǽ���";
                    } else if( (data.ENDDA).compareTo(newDate) < 0 ){
                        data.STATE="����";
                    } else {
                        data.STATE="������";
                    }
                }
                data.IKOST = Double.toString(Double.parseDouble( data.IKOST ) * 100.0 );
            }

            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Object key) throws GeneralException{
        setFields(function, key);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C02Curri.C02CurriInfoData";
        String tableName = "P_EDU_INFORM";
        return getTable(entityName, function, tableName);
    }
}
