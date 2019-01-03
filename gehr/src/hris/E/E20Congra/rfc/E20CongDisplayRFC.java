package hris.E.E20Congra.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.E.E20Congra.E20CongcondData;

import java.util.Vector;


/**
 * E20CongDisplayRFC.java
 * ��������ȸ RFC �� ȣ���ϴ� Class
 *
 * @author �ڿ���
 * @version 1.0, 2001/12/18
 * @version v1.1, 2005/11/03 C2005101901000000340 :ȸ�������߰�
 */
public class E20CongDisplayRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_CONGCOND_DISPLAY";
	private String functionName = "ZGHR_RFC_CONGCOND_DISPLAY";

    /**
     * ��������ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongDisplay( SAPType sapType,String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            Vector ret;


            setInput(function, empNo);
            excute(mConnection, function);
            if (!sapType.isLocal())  ret  = getTable(hris.E.E20Congra.Global.E20CongcondData.class, function, "T_RESULT");
            else
            {
            	ret  = getTable(hris.E.E20Congra.E20CongcondData.class, function, "T_RESULT");
                for ( int i = 0 ; i < ret.size() ; i++ ) {
                	E20CongcondData data = (E20CongcondData)ret.get(i);
                	data.WAGE_WONX = Double.toString(Double.parseDouble(data.WAGE_WONX) * 100.0 ) ; //����ӱ�
                	data.CONG_WONX = Double.toString(Double.parseDouble(data.CONG_WONX) * 100.0 ) ; // ������
                	data.RTRO_WONX = Double.toString(Double.parseDouble(data.RTRO_WONX) * 100.0 ) ; // �ұ�����
                	data.RFUN_AMNT = Double.toString(Double.parseDouble(data.RFUN_AMNT) * 100.0 ) ; // v1.1���޾�
                }
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
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

}


