/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �λ�������ȸ                                                */
/*   Program Name : �λ��Ϻ� ��ȸ �� ���                                     */
/*   Program ID   : A01PersonalCardPrintBinaryRFC                                          */
/*   Description  : �λ��Ϻ� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class (���� A01PersonalCardRFC�� ȣ������ �ʰ�,  SAP���� PDF���Ϸ� �޾� ����� �� �ֵ��� ����                   */
/*   Creation     : 2014/05/30 ������     [CSR ID:2553584] �λ��Ϻ� ��� ���� ����           */
/*                                                                              */
/********************************************************************************/

package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import hris.A.*;

public class A01PersonalCardPrintBinaryRFC extends SAPWrap {

    private  static String functionName = "ZHRA_RFC_GET_PERSONAL_CARD_PDF";

    /**
     * ������ �λ��Ϻ� PDF������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getData( String empNo ,String screen, String LeaderPernr ) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,screen,LeaderPernr);
            excute(mConnection, function);

            Vector ret = null;

            ret = getBinary(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo ,String screen, String LeaderPernr ) throws GeneralException {  
        setField(function, "L_PERNR", empNo);
        
        // C20140210_84209 
        setField(function, "LOG_FLAG", screen);
        setField(function, "LOG_PERNR", LeaderPernr);        
    }
    
    /**
     * RFC ������ Binary Table�� Vector�� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getBinary(JCO.Function function) throws GeneralException {
    	Vector result = new Vector();
    	result = getTable(function, "ET_LINES");
    	return result;
    }
}
