trigger MaintenanceRequest on Case (before update, after update) {
    Map<Id, Case> caseMap = new Map<Id, Case>();

    if (Trigger.isUpdate && Trigger.isAfter) {
        for (Case req_i : Trigger.new) {
            if ((req_i.Type == 'Repair' || req_i.Type == 'Routine Maintenance') 
                && req_i.IsClosed) {
                    caseMap.put(req_i.Id, req_i);
            }
        }
        if (caseMap.size() > 0) {
            MaintenanceRequestHelper.updateWorkOrders(caseMap);
        }
    }
}