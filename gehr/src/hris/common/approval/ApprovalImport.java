package hris.common.approval;

import java.util.HashMap;
import java.util.Vector;

/**
 * Created by manyjung on 2016-10-20.
 */
public class ApprovalImport extends HashMap<String, Vector> {

    public ApprovalImport() {
    }

    public ApprovalImport(String tableName, Vector table) {
        this();
        addTable(tableName, table);
    }

    public void addTable(String tableName, Vector table) {
        put(tableName, table);
    }

}
