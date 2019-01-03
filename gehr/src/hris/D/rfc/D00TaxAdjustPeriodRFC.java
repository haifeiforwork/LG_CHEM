package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D00TaxAdjustPeriodRFC.java
 *  �������� Simulation�� ���� �Ⱓ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/02/04
 */
public class D00TaxAdjustPeriodRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_P_ACCURATE_ACCOUNT" ;

    /**
     * �������� Simulation�� ���� �Ⱓ�� �������� RFC ȣ���ϴ� Method, �Ⱓ�� ������ �� �����͸� �����Ѵ�
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
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
                Logger.debug.println(this,"���������� ���� �Ⱓ�� �����Ǿ����� �ʽ��ϴ�. table : ZHRC072T");
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
     * �������� Simulation�� ���� �Ⱓ�� �������� RFC ȣ���ϴ� Method, �Ⱓ�� ������ �� �����͸� �����Ѵ�
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
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
                Logger.debug.println(this,"���������� ���� �Ⱓ�� �����Ǿ����� �ʽ��ϴ�. table : ZHRC072T");
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode ,String pernr  ) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, pernr );
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode ) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
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