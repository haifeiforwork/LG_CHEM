package hris.D.D01OT.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D01OT.*;


/**
 * D01OTAFCheckRFC.java
 * �ʰ��ٹ� �ش翩�θ� ýũ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2018/05/23
 */
public class D01OTAFCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_NTM_AFTOT_AVAIL_CHECK";

    /**
     * �ʰ��ٹ� ���Ľ�û üũ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param java.lang.String I_SPRSL	���Ű
     * @exception com.sns.jdf.GeneralException
     */
    public Vector AFCheck(Vector T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setTable(function, "T_RESULT", T_RESULT);

            excute(mConnection, function);

            Vector ret = getOutput(function);
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
	 * @param java.lang.String SPRSL
     * @exception com.sns.jdf.GeneralException
     * , String SPRSL
     */
    private void setInput(JCO.Function function, Vector entityVector) throws GeneralException {

    	setTable(function, "T_RESULT", entityVector);

    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {

        Vector ret = new Vector();
    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
        return ret ;
    }
}


