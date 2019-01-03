/********************************************************************************/
/*   System Name  :
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name :
/*   Program ID   : RfcHandler.java
/*   Description  :
/*   Note         :
/*   Creation     : [WorkTime52] 2018-05-04 유정우
/*   Update       :
/********************************************************************************/

package com.sns.jdf.sap;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.sap.mw.jco.JCO.Client;
import com.sap.mw.jco.JCO.Function;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;

/**
 * RFC 호출 공통 Class
 */
public class RfcHandler {

    private static final SAPWrap sapWrap = new SAPWrap();

    /**
     * <pre>
     * RFC 실행 후 결과를 반환
     * 
     * @param rfcName RFC name
     * @param importData RFC IMPORT parameters map
     *     ex) map = {
     *         I_PERNR: '00000000'
     *         I_DATUM: '20180101'
     *     }
     * @return
     * @throws GeneralException
     * </pre>
     */
    public static Map<String, Object> execute(String rfcName, Map<String, Object> importData) throws GeneralException {

        return execute(rfcName, importData, null);
    }

    /**
     * <pre>
     * RFC 실행 후 결과를 반환
     * 
     * @param rfcName RFC name
     * @param importData RFC IMPORT parameters map
     *     ex) map = {
     *         I_PERNR: '00000000'
     *         I_DATUM: '20180101'
     *     }
     * @param inTablesData RFC TABLES parameters map
     *     ex) map = {
     *         T_WKTYP: [
     *             {PERNR: '00000000', DATUM: '20180101', WKTYP: 'A'},
     *             {PERNR: '00000000', DATUM: '20180101', WKTYP: 'B'},
     *             ...
     *         ],
     *         I_WKLIS: [
     *             {WKTYP: 'A', RDATA: 'Hi'},
     *             {WKTYP: 'A', RDATA: 'Hello'},
     *             ...
     *         ]
     *     }
     * @return
     * @throws GeneralException
     * </pre>
     */
    @SuppressWarnings("serial")
    public static Map<String, Object> execute(String rfcName, Map<String, Object> importData, Map<String, List<Map<String, Object>>> inTablesData) throws GeneralException {

        Client client = null;
        try {
            client = sapWrap.getClient();
            final Function function = sapWrap.createFunction(rfcName);

            // Import parameter 셋팅
            if (MapUtils.isNotEmpty(importData)) {
            	Logger.debug.println(sapWrap, "********** setImportData() " + importData);
                RfcDataHandler.setImportData(function, importData);
            }

            // 입력 Tables parameter 셋팅
            if (MapUtils.isNotEmpty(inTablesData)) {
            	Logger.debug.println(sapWrap, "********** setTablesData() " + inTablesData);
                RfcDataHandler.setTablesData(function, inTablesData);
            }

            // RFC 실행
            sapWrap.excute(client, function);

            // Export parameter 추출
            final Map<String, Object> exportData = RfcDataHandler.getExportData(function);

            // 출력 Tables parameter 추출
            final Map<String, List<Map<String, Object>>> outTablesData = RfcDataHandler.getTablesData(function);

            return new HashMap<String, Object>() {
                {
                    if (MapUtils.isNotEmpty(exportData))    {
                    	Logger.debug.println(sapWrap, "********** getExportData() " + exportData);
                    	put("EXPORT", exportData);    // Export data
                    }
                    if (MapUtils.isNotEmpty(outTablesData)) {
                    	Logger.debug.println(sapWrap, "********** getTablesData() " + outTablesData);
                    	put("TABLES", outTablesData); // Tables data
                    }
                }
            };

        } catch (GeneralException e) {
            Logger.error(e);
            throw e;

        } finally {
            sapWrap.close(client);

        }
    }

}