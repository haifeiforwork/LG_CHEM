package hris.C.C10Education.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C10Education.*;

/**
 * C10EducationEventListRFC.java
 * ���� ���� list�� �д´�.
 *
 * @author  �赵��
 * @version 1.0, 2005/05/28
 */
public class C10EducationEventListRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EDUCATION_EVENT_LIST";

    /**
     * @param i_objid java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getList( String i_objid ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_objid);
            excute(mConnection, function);

            Vector ret = getOutput(function);

//          ���� ������ ���� ���� ����
            String newDate = WebUtil.printDate( DataUtil.getCurrentDate(), "-" );
            for ( int i = 0 ; i < ret.size() ; i++ ){
                C10EducationEventListData data = (C10EducationEventListData)ret.get(i);
                if( data.SDATE.equals("0000-00-00") ||data.SDATE.equals("")){
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
        } catch(Exception ex){
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
     * @param i_objid java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_objid) throws GeneralException {
        String fieldName = "I_OBJID";
        setField( function, fieldName, i_objid );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C10Education.C10EducationEventListData";
        
        return getTable(entityName, function, "T_RESULT2");
    }
}


