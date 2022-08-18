trigger AssignAllRelatedTaskstoProgramTest on Program_Assignment__c (before insert, after insert,before delete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        DuplicatesCheckerForProgram.checkPrograms(Trigger.new);
    }
    else if(Trigger.isAfter && Trigger.isInsert) {
            AssignAllRelatedTaskstoProgram.assignAllTasks(Trigger.new);

        }
    else if(Trigger.isBefore && Trigger.isDelete) {
        DeleteAllTasksFromProgram.deleteAssignedEmployeeTask(Trigger.oldMap);
    }
}

