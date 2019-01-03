package hris.E.E09House.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E09House.*;

/**
 * E09HouseDetailRFC.java
 * �����ڱ����� ���γ����� ��ȸ �ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author �ڿ���
 * @version 1.0, 2002/12/31
 */
public class E09HouseDetailRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_HOUSE_FUND_DETAIL";
    private String functionName = "ZGHR_RFC_HOUSE_FUND_DETAIL";

    /**
     * �����ڱ����� ���γ��� ��ȸ RFC ȣ���ϴ� Method
     * @param empNo java.lang.Object
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Object getHouseDetail( Object key ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            Logger.debug.println(this, key.toString());
            setInput(function, key);
            excute(mConnection, function);
            E09HouseDetailData data = (E09HouseDetailData)getOutput(function);

            data.E_BETRG           = Double.toString(Double.parseDouble(data.E_BETRG         ) * 100.0 );
            data.E_DARBT           = Double.toString(Double.parseDouble(data.E_DARBT         ) * 100.0 );
            data.E_REMAIN_BETRG    = Double.toString(Double.parseDouble(data.E_REMAIN_BETRG  ) * 100.0 );
            data.E_TILBT           = Double.toString(Double.parseDouble(data.E_TILBT         ) * 100.0 );
            data.E_TILBT_BETRG     = Double.toString(Double.parseDouble(data.E_TILBT_BETRG   ) * 100.0 );
            data.E_TOTAL_DARBT     = Double.toString(Double.parseDouble(data.E_TOTAL_DARBT   ) * 100.0 );
            data.E_TOTAL_INTEREST  = Double.toString(Double.parseDouble(data.E_TOTAL_INTEREST) * 100.0 );
            Logger.debug.println(this, data.toString());
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
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Object key ) throws GeneralException {
        setFields( function, key);

    }
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Object getOutput(JCO.Function function) throws GeneralException {
        E09HouseDetailData data = new E09HouseDetailData();
        return getFields(data, function);
    }

}
