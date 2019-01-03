package hris.D.D06Ypay.rfc ;

import java.util.Vector;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;

import hris.D.D06Ypay.D06YpayTaxDetailData;

/**
 *  D06YpayTaxDetailRFC.java
 *  �������� ��������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2002/01/31
 *   Update       : 2013-06-24 [CSR ID:2353407] sap�� �߰��ϰ��� �߰� ��  
 */
public class D06YpayTaxDetailRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_READ_YEA_RESULT2" ;

    /**
     * �������� ��������� �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @param GJAHR java.lang.String ȸ��⵵
     * @exception com.sns.jdf.GeneralException
     */
    public Object getTaxDetail( String empNo, String GJAHR, Area area) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, GJAHR);
            excute(mConnection, function);
            Vector ret = getOutput( function );
            D06YpayTaxDetailData data = (D06YpayTaxDetailData)metchData(ret, area);
 
            return data;
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
     * @param empNo java.lang.String ���
     * @param GJAHR java.lang.String ȸ��⵵
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String GJAHR ) throws GeneralException {
       
        setField( function, "PERNR", empNo );
        
        setField( function, "GJAHR", GJAHR );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        return getCodeVector( function, "RTAB",  "LGART",  "BETRG" );
    }


    private Object metchData(Vector ret, Area area) throws GeneralException {

        D06YpayTaxDetailData retData = new D06YpayTaxDetailData();

        for( int i = 0 ; i < ret.size() ; i++ ){
            CodeEntity data = (CodeEntity)ret.get(i);
          if(data.value.equals("")){data.value="";}else{ data.value = DataUtil.changeLocalAmount(data.value, area);}   

            if(data.code.equals("/YAI")){
                retData.YAI = data.value; 
            }else if(data.code.equals("/YAR")){
                retData.YAR = data.value; 
            }else if(data.code.equals("/YAS")){
                retData.YAS = data.value; 
            }else if(data.code.equals("1504")){
                retData.TAX = data.value; 
            }else if(data.code.equals("/Y1C")){
                retData.YIC = data.value;
            }else if(data.code.equals("/YFE")){
                retData.YFE = data.value; 
            }
        }

Logger.debug.println(this, retData.toString());
        return retData ;
    }
}