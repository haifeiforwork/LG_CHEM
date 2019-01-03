package hris.C.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.C.* ;

/**
 * C03EduEntdateRFC.java
 * ����� �Ի����ڸ� �������� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2017/10/16
 * [CSR ID:3504688] Global Academy �����̷� I/F ���� ��û
 */
public class C03EduEntdateRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_EDU_ENTDATE" ;

    /**
     * ����� �Ի����ڸ� �������� RFC�� ȣ���ϴ� Method
     *  @param     java.lang.String �����ȣ
     *  @return     java.lang.String
     *  @exception com.sns.jdf.GeneralException
     */
    public String getEduEntDate(String PERNR) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField( function, "I_PERNR", PERNR ) ;
            excute(mConnection, function);
            return getField("E_DATE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }



}
