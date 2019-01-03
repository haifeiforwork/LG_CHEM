package	hris.E.E25Infojoin.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E25Infojoin.*;

/**
 * InformalListRFC.java
 * ������ ����Ʈ�� �������� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class InfoListRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_P_INFORMAL_LIST";
	private String functionName = "ZGHR_RFC_P_INFORMAL_LIST";

    /**
     * ���дɷ����� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String�����ȣ java.lang.String �����ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInfoList(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);

            excute(mConnection, function);

            Vector ret = getTable(InfoListData.class, function, "T_RESULT");
            Logger.debug.println(this, "ret"+ret.toString());
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
     * @param function com.sap.mw.jco.JCO.Function java.lang.String java.lang.String
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
   private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR"          ;
        setField(function, fieldName, empNo);
    }

}