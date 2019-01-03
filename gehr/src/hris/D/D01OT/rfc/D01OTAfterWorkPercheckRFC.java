package hris.D.D01OT.rfc;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;

import hris.B.B04Promotion.B04PromotionCData;
import hris.D.D15RetirementSimulData;
import hris.D.D01OT.D01OTData;
import hris.D.D01OT.D01OTAfterWorkTimeDATA;	//사무직
import hris.D.D03Vocation.D03RemainVocationData;
import hris.common.approval.ApprovalSAPWrap;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang.StringUtils;
import java.util.Vector;


/**
 * D01OTAfterWorkPercheckRFC.java
 * 초과근무 사후신청시 사원체크 조회 RFC 를 호출하는 Class
 *
 * @author 강동민
 * @version 1.0, 2018/06/11
 */
public class D01OTAfterWorkPercheckRFC extends ApprovalSAPWrap {

	private String functionName = "ZGHR_RFC_NTM_AFTOT_PERCHK";

    /**
     * 사원체크 호출하는 Method
     * @retul.Vector
     * @excens.jdf.GeneralException
     */
    public  D01OTAfterWorkTimeDATA getResult(String I_PERNR, String I_DATUM, String I_SPRSL) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR"    	, I_PERNR    );
			setField(function, "I_DATUM"    	, I_DATUM    );
            setField(function, "I_SPRSL"    	, I_SPRSL    );

            excute(mConnection, function, null);

            //D01OTAfterWorkTimeDATA 	d01OTAfterWorkTimeDATA 	= new D01OTAfterWorkTimeDATA();
            //d01OTAfterWorkTimeDATA =  getFields((new B04PromotionCData()), function);
            D01OTAfterWorkTimeDATA data = (D01OTAfterWorkTimeDATA)getOutput( function, new D01OTAfterWorkTimeDATA() );

            D01OTAfterWorkTimeDATA export = (D01OTAfterWorkTimeDATA) getFields((new D01OTAfterWorkTimeDATA()) , function);

			return data;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public  D01OTAfterWorkTimeDATA getPRECHECK(String I_PERNR, String I_DATUM, String I_SPRSL) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR"    	, I_PERNR    );
			setField(function, "I_DATUM"    	, I_DATUM    );
            setField(function, "I_SPRSL"    	, I_SPRSL    );

            excute(mConnection, function, null);

            D01OTAfterWorkTimeDATA export = (D01OTAfterWorkTimeDATA) getFields((new D01OTAfterWorkTimeDATA()) , function);

			return export;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }



    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        return getExportFields(data, function,"");
    }


}


