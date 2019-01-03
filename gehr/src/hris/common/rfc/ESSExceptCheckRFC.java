package hris.common.rfc;

import java.util.*;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D03Vocation.*;
import hris.D.D20Flextime.D20FlextimeData;

/**
 * ZGHR_RFC_EXPCD_LIST
 * ���� ESS ��û �� ���� ��� ���� üũ Class
 * �Է� field 
 * �ʵ�ID	    Key	Type
I_PERNR		NUMC
I_MOLGA		CHAR
I_DATUM		DATS
I_SPRSL		LANG
I_ZEXPCD		CHAR

 * ��� field  
 * E_RETURN    : S:���� E:���� N:����Ʈ ����
 * 
 * except table
 * EXPCD		CHAR	 4 	���ܻ���
EXPCDT		CHAR	 40 	���ܻ��׸�
EXPTG		CHAR	 20 	��������
BEGDA		DATS	 8 	������
ENDDA		DATS	 8 	������

create date : 2017-12-01  [CSR ID:3546961] ����ȭȯ ��û ������ ��
author : ������D

 * 
 */
public class ESSExceptCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_EXPCD_LIST";

    /**
     * ESS ��û �� ���� ��� ���� Ȯ��
     * @return E_RETURN(MSGTY : 1, MSGTX : 255)   : S:���� E:���� N:����Ʈ ����
     * @exception com.sns.jdf.GeneralException
     */

    public RFCReturnEntity essExceptcheck(String pernr, String zexpcd) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            String sysDate = WebUtil.printDate( DataUtil.getCurrentDate(), "-" );
            
            setField(function, "I_PERNR", pernr);
            setField(function, "I_BEGDA", sysDate);
            setField(function, "I_ZEXPCD", zexpcd);
            
            excute(mConnection, function);
            return getReturn();

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}