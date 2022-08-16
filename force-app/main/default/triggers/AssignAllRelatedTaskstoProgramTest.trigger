trigger AssignAllRelatedTaskstoProgramTest ON Program_Assignment__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        if(DuplicatesCheckerForProgram.checkPrograms(Trigger.new)){
            AssignAllRelatedTaskstoProgram.assignAllTasks(Trigger.new);

        }
    }
}
