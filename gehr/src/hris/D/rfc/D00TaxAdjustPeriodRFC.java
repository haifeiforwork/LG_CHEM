package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D00TaxAdjustPeriodRFC.java
 *  연말정산 Simulation을 위한 기간을 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/02/04
 */
public class D00TaxAdjustPeriodRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_P_ACCURATE_ACCOUNT" ;

    /**
     * 연말정산 Simulation을 위한 기간을 가져오는 RFC 호출하는 Method, 기간이 없으면 빈 데이터를 리턴한다
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public Object getPeriod( String companyCode  ,String pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode,pernr);
            excute(mConnection, function);

            Vector Data_vt = getOutput( function );
            D00TaxAdjustPeriodData data = null;
            Logger.debug.println(this,"pernr  :  "+pernr);
            Logger.debug.println(this,"Data_vt desc:  "+Data_vt.toString());
            if(Data_vt.size() > 0){

                //data = (D00TaxAdjustPeriodData)Data_vt.get(0);
                long CurrentDate = Long.parseLong(DataUtil.removeStructur(DataUtil.getCurrentDate(),"-"));
                long APPL_FROM;
                long APPL_TOXX;
                long SIMU_FROM;
                long SIMU_TOXX;
                long DISP_FROM;
                long DISP_TOXX;
                Data_vt=SortUtil.sort_num(Data_vt , "YEA_YEAR", "desc" ); // Number

                Logger.debug.println(this,"Data_vt desc:  "+Data_vt.toString());
                for( int i = 0 ; i < Data_vt.size() ; i++ ) {
                	D00TaxAdjustPeriodData data1 = (D00TaxAdjustPeriodData)Data_vt.get(i) ;


                    APPL_FROM = Long.parseLong(DataUtil.removeStructur(data1.APPL_FROM,"-"));
                    APPL_TOXX = Long.parseLong(DataUtil.removeStructur(data1.APPL_TOXX,"-"));
                    SIMU_FROM = Long.parseLong(DataUtil.removeStructur(data1.SIMU_FROM,"-"));
                    SIMU_TOXX = Long.parseLong(DataUtil.removeStructur(data1.SIMU_TOXX,"-"));
                    DISP_FROM = Long.parseLong(DataUtil.removeStructur(data1.DISP_FROM,"-"));
                    DISP_TOXX = Long.parseLong(DataUtil.removeStructur(data1.DISP_TOXX,"-"));
                    if  (   ( CurrentDate  >= APPL_FROM  && CurrentDate  <= APPL_TOXX  )
                		|| ( CurrentDate  >= SIMU_FROM  && CurrentDate  <= SIMU_TOXX  )
                		|| ( CurrentDate  >= DISP_FROM  && CurrentDate  <= DISP_TOXX  )    )
                    {
                        data = (D00TaxAdjustPeriodData)Data_vt.get(i);
                        Logger.debug.println(this,"i:"+i + "data set :  "+data.toString());
                    }
                }
                Logger.debug.println(this,"data desc:======  " );
                if (data == null){
                    Logger.debug.println(this,"data null:  "+Data_vt.toString());
                    data = (D00TaxAdjustPeriodData)Data_vt.get(0);
                }

                Logger.debug.println(this,"data desc:  "+data.toString());
            } else {
                data = new D00TaxAdjustPeriodData();
                Logger.debug.println(this,"연말정산을 위한 기간이 설정되어있지 않습니다. table : ZHRC072T");
            }

            return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 연말정산 Simulation을 위한 기간을 가져오는 RFC 호출하는 Method, 기간이 없으면 빈 데이터를 리턴한다
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public Object getPeriod( String companyCode ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode);
            excute(mConnection, function);

            Vector vt = getOutput( function );
            D00TaxAdjustPeriodData data = null;
            if(vt.size() == 1){
                data = (D00TaxAdjustPeriodData)vt.get(0);
            } else {
                data = new D00TaxAdjustPeriodData();
                Logger.debug.println(this,"연말정산을 위한 기간이 설정되어있지 않습니다. table : ZHRC072T");
            }

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
     * @param empNo java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode ,String pernr  ) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, pernr );
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode ) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D00TaxAdjustPeriodData";
        String tableName  = "T_RESULT";
        return getTable(entityName, function, tableName);
    }
}