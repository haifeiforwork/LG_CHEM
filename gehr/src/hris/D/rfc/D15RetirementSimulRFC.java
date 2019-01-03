package hris.D.rfc ;

import java.math.BigDecimal;
import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D15RetirementSimulRFC.java
 *  퇴직금소득공제 Simulation을 위한 기초자료를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/02/06
 *                     2015/07/30 [CSR ID:2838889] 퇴직금 시뮬레이션 세금로직 변경 요청의 건
 */
public class D15RetirementSimulRFC extends SAPWrap {

   // private static String functionName = "ZHRP_RFC_SIM_CALC_RSGN_AMT" ;
	 private static String functionName = "ZGHR_RFC_SIM_CALC_RSGN_AMT" ;

    /**
     * 퇴직금소득공제 Simulation을 위한 기초자료를 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @param I_DATE java.lang.String 예상퇴직일자
     * @exception com.sns.jdf.GeneralException
     */
    public Object getRetirementData( String empNo, String I_DATE ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, I_DATE);
            excute(mConnection, function);
            D15RetirementSimulData data = (D15RetirementSimulData)getOutput( function, new D15RetirementSimulData() );
            // 보험사명과 지급액 가져와서 가공
            Vector code_vt = (Vector)getOutputTable(function);
            CodeEntity codeEnt = null;
            if( code_vt.size() > 0 ){
                codeEnt = (CodeEntity)code_vt.get(0);
                data.INS1_NAME1 = codeEnt.code;
                data.JON1_AMNT1 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            if( code_vt.size() > 1 ){
                codeEnt = (CodeEntity)code_vt.get(1);
                data.INS1_NAME2 = codeEnt.code;
                data.JON1_AMNT2 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            if( code_vt.size() > 2 ){
                codeEnt = (CodeEntity)code_vt.get(2);
                data.INS1_NAME3 = codeEnt.code;
                data.JON1_AMNT3 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );

                Logger.debug.println(this,"[퇴직금시뮬레이션] 보험사가 2개이상입니다.???");
            }
            if( code_vt.size() > 3 ){
                codeEnt = (CodeEntity)code_vt.get(3);
                data.INS1_NAME4 = codeEnt.code;
                data.JON1_AMNT4 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            if( code_vt.size() > 4 ){
                codeEnt = (CodeEntity)code_vt.get(4);
                data.INS1_NAME5 = codeEnt.code;
                data.JON1_AMNT5 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 5 ){
                codeEnt = (CodeEntity)code_vt.get(5);
                data.INS1_NAME6 = codeEnt.code;
                data.JON1_AMNT6 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 6 ){
                codeEnt = (CodeEntity)code_vt.get(6);
                data.INS1_NAME7 = codeEnt.code;
                data.JON1_AMNT7 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 7 ){
                codeEnt = (CodeEntity)code_vt.get(7);
                data.INS1_NAME8 = codeEnt.code;
                data.JON1_AMNT8 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 8 ){
                codeEnt = (CodeEntity)code_vt.get(8);
                data.INS1_NAME9 = codeEnt.code;
                data.JON1_AMNT9 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }

            if( code_vt.size() > 9 ){
                codeEnt = (CodeEntity)code_vt.get(9);
                data.INS1_NAME10 = codeEnt.code;
                data.JON1_AMNT10 = Double.toString(Double.parseDouble(codeEnt.value) * 100.0 );
            }
            DataUtil.fixNull(data);

            Logger.debug.println(this, data.toString());

            data.WAGE_AVER =Double.toString(Double.parseDouble(data.WAGE_AVER) * 100.0 ); // 평균임금
            data.GRNT_RSGN =Double.toString(Double.parseDouble(data.GRNT_RSGN) * 100.0 ); // 퇴직금총액
            //data.O_ZIPY01  =Double.toString(Double.parseDouble(data.O_ZIPY01 ) * 100.0 ); // 보험사지급액1
            //data.O_ZIPY02  =Double.toString(Double.parseDouble(data.O_ZIPY02 ) * 100.0 ); // 보험사지급액2
            data.O_BONDM   =Double.toString(Double.parseDouble(data.O_BONDM  ) * 100.0 ); // 채권가압류공제
            data.O_HLOAN   =Double.toString(Double.parseDouble(data.O_HLOAN  ) * 100.0 ); // 주택자금공제
            data.O_NAPPR   =Double.toString(Double.parseDouble(data.O_NAPPR  ) * 100.0 ); // 퇴직전환금
            data.INC_TAX   =Double.toString(Double.parseDouble(data.INC_TAX  ) * 100.0 ); // [CSR ID:2838889] 퇴직갑근세
            data.RES_TAX   =Double.toString(Double.parseDouble(data.RES_TAX  ) * 100.0 ); // [CSR ID:2838889] 퇴직주민세

            return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사번
     * @param I_DATE java.lang.String 예상퇴직일자
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String I_DATE ) throws GeneralException {
        //String fieldName1 = "PERNR";
    	String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_DATE";
        setField( function, fieldName2, I_DATE );
    }

// Export Return type이 Object 인 경우 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행후 Export 값을 Object 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        //return getFields(data, function);
    	return getExportFields(data, function,"");
    }
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputTable(JCO.Function function) throws GeneralException {
        //String tableName  = "ZHRPI00S";      // RFC Export 구성요소 참조
    	String tableName  = "T_ZHRPI00S";      // RFC Export 구성요소 참조
        String codeField  = "INS1_NAME";
        String valueField = "JON1_AMNT";
        return getCodeVector( function, tableName, codeField, valueField );
    }

    /**
     * 퇴직금소득공제 Simulation을 위한 기초자료를 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @param beginDate java.lang.String 시작일
     * @param endDate java.lang.String 종료일
     * @exception com.sns.jdf.GeneralException
     */
    public Object simulate( D15RetirementSimulData data ) throws GeneralException {
        try{
            double _퇴직금총액     = Double.parseDouble(data.GRNT_RSGN );
            //double _퇴직수당     = Double.parseDouble(data._퇴직수당 );  // ????????? 퇴직수당이 퇴직금총액에 포함되어있다는 가정..
            double _퇴직전환금     = Double.parseDouble(data.O_NAPPR   );
            double _보험사지급액1  = Double.parseDouble(data.JON1_AMNT1.equals("")?"0":data.JON1_AMNT1);
            double _보험사지급액2  = Double.parseDouble(data.JON1_AMNT2.equals("")?"0":data.JON1_AMNT2);
            double _보험사지급액3  = Double.parseDouble(data.JON1_AMNT3.equals("")?"0":data.JON1_AMNT3);
            double _보험사지급액4  = Double.parseDouble(data.JON1_AMNT4.equals("")?"0":data.JON1_AMNT4);
            double _보험사지급액5  = Double.parseDouble(data.JON1_AMNT5.equals("")?"0":data.JON1_AMNT5);
            double _보험사지급액6  = Double.parseDouble(data.JON1_AMNT6.equals("")?"0":data.JON1_AMNT6);
            double _보험사지급액7  = Double.parseDouble(data.JON1_AMNT7.equals("")?"0":data.JON1_AMNT7);
            double _보험사지급액8  = Double.parseDouble(data.JON1_AMNT8.equals("")?"0":data.JON1_AMNT8);
            double _보험사지급액9  = Double.parseDouble(data.JON1_AMNT9.equals("")?"0":data.JON1_AMNT9);
            double _보험사지급액10  = Double.parseDouble(data.JON1_AMNT10.equals("")?"0":data.JON1_AMNT10);
            double _채권가압류공제 = Double.parseDouble(data.O_BONDM   );
            double _주택자금공제   = Double.parseDouble(data.O_HLOAN   );
            double _퇴직갑근세 = 0.0;
            double _퇴직주민세 = 0.0;
            double _차감지급액 = 0.0;
            double _공제총액   = 0.0;

            double _퇴직소득공제     = 0.0;
            double _퇴직소득과세표준 = 0.0;
            double _기본세율         = 0.0;
            double _퇴직소득산출세액 = 0.0;
            double _퇴직소득세액공제 = 0.0;
            double _퇴직소득결정세액 = 0.0;

            //double _퇴직연평균과세표준 = 0.0;
            double _퇴직연평균산출세액 = 0.0;

            double MANWON = 10000.0 ; // 한화 만원
            // 근속년수 절상
            int financeYear = Integer.parseInt(data.fu_retireDate.substring(0,4));
            int workYear = Integer.parseInt(data.SERV_PROD_Y);
            if( Integer.parseInt(data.SERV_PROD_M) > 0 ){
                workYear += 1;
            }
            Logger.debug.println(this,"Retirement Simulating... 퇴직년도 : "+financeYear+", 근속년도 : "+workYear);
           /*------------  퇴직갑근세 계산 -----------------------*/
            // 퇴직소득공제 계산 @2011변경
            _퇴직소득공제  = _퇴직금총액 * 0.4 ;
            //_퇴직소득공제  = (_퇴직금총액 - _퇴직수당) * 0.5 ;
            //_퇴직소득공제 += _퇴직수당  * 0.75 ;
            if(workYear > 0 && workYear <= 5){
                _퇴직소득공제 += (double)workYear * 30*MANWON;        // 1년당 30만원
            } else if(workYear > 5 && workYear <= 10){
                _퇴직소득공제 += 150*MANWON + (double)(workYear - 5)*50*MANWON;
            } else if(workYear > 10 && workYear <= 20){
                _퇴직소득공제 += 400*MANWON + (double)(workYear - 10)*80*MANWON;
            } else if(workYear > 20){
                _퇴직소득공제 += 1200*MANWON + (double)(workYear - 20)*120*MANWON;
            }

            // 퇴직소득과세표준 = 퇴직급여 - 퇴직소득공제
            _퇴직소득과세표준 = _퇴직금총액 - _퇴직소득공제;

            //_퇴직연평균과세표준 = _퇴직소득과세표준 / (double)workYear;

            Logger.debug.println(this,"####_퇴직소득공제 : "+_퇴직소득공제+", _퇴직소득과세표준 : "+_퇴직소득과세표준);

            // 기본세율 계산
            /*
            if( _퇴직연평균과세표준 > 0 && _퇴직연평균과세표준 <= ( 1000*MANWON ) ){
                _기본세율 = 0.09 ;
            } else if( (_퇴직연평균과세표준 > ( 1000*MANWON )) && (_퇴직연평균과세표준 <= ( 4000*MANWON )) ){
                _기본세율 = 0.18 ;
            } else if( (_퇴직연평균과세표준 > ( 4000*MANWON )) && (_퇴직연평균과세표준 <= ( 8000*MANWON )) ){
                _기본세율 = 0.27 ;
            } else if( _퇴직연평균과세표준 > ( 8000*MANWON ) ){
                _기본세율 = 0.36 ;
            }
            // @2011변경    과세표준	세율
            //12,000,000	6%
            //46,000,000	15%
            //88,000,000	24%
            // 	35%
            if( _퇴직연평균과세표준 > 0 && _퇴직연평균과세표준 <= ( 1200*MANWON ) ){
                _기본세율 = 0.06 ;
            } else if( (_퇴직연평균과세표준 > ( 1200*MANWON )) && (_퇴직연평균과세표준 <= ( 4600*MANWON )) ){
                _기본세율 = 0.15 ;
            } else if( (_퇴직연평균과세표준 > ( 4600*MANWON )) && (_퇴직연평균과세표준 <= ( 8800*MANWON )) ){
                _기본세율 = 0.24 ;
            } else if( _퇴직연평균과세표준 > ( 8800*MANWON ) ){
                _기본세율 = 0.35 ;
            }*/

            /* 2013.04 세법변경 */
            /*
            _퇴직연평균산출세액 =  (_퇴직연평균과세표준 * _기본세율);
            BigDecimal calYearRate = new BigDecimal(_퇴직연평균산출세액).setScale(0, BigDecimal.ROUND_FLOOR);  //소숫점에서 절삭
            _퇴직연평균산출세액 = Double.parseDouble( calYearRate.toString());//일의자리에서 절삭

            // 퇴직소득산출세액 = 퇴직소득과세표준 / 근속연수 * 기본세율(10~40%) * 근속연수
            _퇴직소득산출세액 = _퇴직연평균산출세액 * (double)workYear;
            BigDecimal calRate = new BigDecimal(_퇴직소득산출세액*0.1).setScale(0, BigDecimal.ROUND_FLOOR);  //일의자리에서 절삭
            _퇴직소득산출세액 = Double.parseDouble( calRate.toString())*10;//일의자리에서 절삭

            */

            //2013.04.05 개정안반영=====start =================
            //각 근속월수(2013년1월1일이후근속월수)
            int Aftr2013Mon= (Integer.parseInt(data.fu_retireDate.substring(0,4))-2012-2)*12
                                +(12+12-Integer.parseInt(data.O_GIDAT.substring(5,7)) + Integer.parseInt(data.fu_retireDate.substring(4,6))+1);//20150819 5,7 -> 4,6 수정
            int Aftr2013Year = Aftr2013Mon/12; //각 근속연수(2013년1월1일이후근속년수)
            int Prev2013Year = workYear-Aftr2013Year; //각 근속연수(2013년1월1일이전근속년수)

            Logger.debug.println(this, "workYear:"+workYear+  "Aftr2013Mon : "+Aftr2013Mon+ "  Aftr2013Year : "+Aftr2013Year+ "  Prev2013Year : "+Prev2013Year);

            //<2012.12.31이전>
            //z-1 과세표준안분 =  d 퇴직연평균 과세표준*각 근속연수(2012년이전근속년수)/정산근속연수
            //d -1 퇴직연평균과세표준=과세표준안분/각 근속연수
            //연평균산출세액=퇴직연평균과세표준*세율
            //산출세액=연평균산출세액*각 근속연수

            double _Prev2013과세표준안분 = 0.0;
            double _Prev2013퇴직연평균과세표준 = 0.0;
            double _Prev2013연평균산출세액 = 0.0;
            double _Prev2013산출세액 = 0.0;

            /*_Prev2013과세표준안분 = _퇴직연평균과세표준*Prev2013Year/workYear;
            if(Prev2013Year == 0){
            	_Prev2013퇴직연평균과세표준 = 0;
            }else{
            	_Prev2013퇴직연평균과세표준 = _Prev2013과세표준안분/Prev2013Year;
            }
            _Prev2013연평균산출세액 = _Prev2013퇴직연평균과세표준 * _기본세율;
            _Prev2013산출세액 = _Prev2013연평균산출세액 * Prev2013Year;
            */
            double _Aftr2013과세표준안분 = 0.0;
            double _Aftr2013퇴직연평균과세표준 = 0.0;
            double _Aftr2013연평균산출세액 = 0.0;
            double _Aftr2013환산과세표준 = 0.0;
            double _Aftr2013환산산출세액 = 0.0;
            double _Aftr2013산출세액 = 0.0;

            //<2013.01.01이후>
            //z-2 과세표준안분= d 퇴직연평균 과세표준*각근속연수(2012년이후근속년수)/정산근속연수
            //d -2 퇴직연평균과세표준=과세표준안분/각 근속연수
           // e 환산과세표준=d-2퇴직연평균과세표준*5
            //환산산출세액=e 환산과세표준*세율
            //연평균산출세액=환산산출세액/5
            //산출세액=연평균산출세액*각 근속연수

            /*_Aftr2013과세표준안분 = _퇴직연평균과세표준*Aftr2013Year/workYear;
            _Aftr2013퇴직연평균과세표준 = _Aftr2013과세표준안분/Aftr2013Year;
            _Aftr2013환산과세표준 = _Aftr2013퇴직연평균과세표준*5;
            _Aftr2013환산산출세액 = _Aftr2013환산과세표준 * _기본세율;
            _Aftr2013연평균산출세액 = _Aftr2013환산산출세액/5;
            _Aftr2013산출세액 = _Aftr2013연평균산출세액 * Aftr2013Year;

*/
        //    _퇴직소득산출세액 = _Prev2013산출세액 +_Aftr2013산출세액;

            //2013.04.05 개정안반영 end======================

            BigDecimal calRate = new BigDecimal(_퇴직소득산출세액*0.1).setScale(0, BigDecimal.ROUND_FLOOR);  //일의자리에서 절삭
            _퇴직소득산출세액 = Double.parseDouble( calRate.toString())*10;//일의자리에서 절삭

            Logger.debug.println(this, "  calRate : "+calRate);

            Logger.debug.println(this,"####_기본세율 : "+_기본세율+", _퇴직소득산출세액 : "+_퇴직소득산출세액);

            // 퇴직소득세액공제 계산
            double limit = 0  ;
            double resultTax = 0 ;
            if(financeYear < 2003){
                limit = 24*MANWON * workYear ;
                resultTax = (_퇴직소득산출세액 * 0.5);

            } else if(financeYear == 2003 || financeYear == 2004){
                limit = 12*MANWON * workYear ;
                resultTax = (_퇴직소득산출세액 * 0.25);

            } else if(financeYear >= 2005){
                limit = 0 ;
                resultTax = 0 ;
            }

            Logger.debug.println(this,"####limit : "+limit+", resultTax : "+resultTax);

            _퇴직소득세액공제 = ((resultTax > limit) ? limit : resultTax);

            // 퇴직소득결정세액 = 퇴직소득산출세액 - 퇴직소득세액공제
            _퇴직소득결정세액 = _퇴직소득산출세액 - _퇴직소득세액공제 ;

//            _퇴직갑근세 = DataUtil.nelim( _퇴직소득결정세액 ,-1);
            _퇴직갑근세 = _퇴직소득결정세액;

            //[CSR ID:2838889] 퇴직금 시뮬레이션 세금로직 변경 요청의 건
            //data._퇴직갑근세 = Double.toString(_퇴직갑근세);
            data._퇴직갑근세 = data.INC_TAX;//
           /*------------  퇴직갑근세 계산 End -----------------------*/

            // 퇴직주민세 계산
//            _퇴직주민세 = DataUtil.nelim( (_퇴직갑근세 * 0.1) ,-1);
             _퇴직주민세 = (_퇴직갑근세 * 0.1);
            BigDecimal calJumin = new BigDecimal(_퇴직주민세*0.1).setScale(0, BigDecimal.ROUND_FLOOR);  //일의자리에서 절삭
            _퇴직주민세 = Double.parseDouble( calJumin.toString())*10;//일의자리에서 절삭

            //data._퇴직주민세 = Double.toString(_퇴직주민세);
            data._퇴직주민세 = data.RES_TAX;


            // 공제총액  계산
//          [CSR ID:2838889] 퇴직금 시뮬레이션 세금로직 변경 요청의 건
            //_공제총액 = _퇴직갑근세 + _퇴직주민세 + _퇴직전환금 + _채권가압류공제 + _주택자금공제;
            _공제총액 = Double.parseDouble(data._퇴직갑근세) + Double.parseDouble(data._퇴직주민세) + _퇴직전환금 + _채권가압류공제 + _주택자금공제;
            data._공제총액 = Double.toString(_공제총액);
            // 차감지급액 계산
            _차감지급액 = _퇴직금총액 - _공제총액 ;
            data._차감지급액 = Double.toString(_차감지급액);
            // 회사에서 지급하는 금액 계산
            data._회사지급액 = Double.toString(_퇴직금총액 - _보험사지급액1 - _보험사지급액2 - _보험사지급액3 - _보험사지급액4 - _보험사지급액5- _보험사지급액6 - _보험사지급액7 - _보험사지급액8 - _보험사지급액9 - _보험사지급액10) ;
            return data;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
}