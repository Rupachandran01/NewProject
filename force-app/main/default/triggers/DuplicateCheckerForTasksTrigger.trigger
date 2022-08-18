trigger DuplicateCheckerForTasksTrigger on Employee_Program_Task__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        DuplicateCheckerForTasks.checkTasks(Trigger.new);
        UpdateDueDateForIndivTasks.updateDueDates(Trigger.new);

    }
}
