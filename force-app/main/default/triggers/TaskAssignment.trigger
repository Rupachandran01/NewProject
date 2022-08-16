trigger TaskAssignment on Task_Assignment__c (before insert, after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        UpdateAssignedTaskInProgram.updateNewTasks(Trigger.new);
    }
}