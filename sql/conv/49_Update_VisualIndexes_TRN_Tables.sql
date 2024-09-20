	update [sma_TRN_WorkPlanItems] 
	SET [VisualIndex] = 1
	WHERE [VisualIndex] IS NULL OR [VisualIndex] = 0

	DECLARE @ID int
	DECLARE IDs CURSOR LOCAL FOR select [uId] from [sma_TRN_WorkPlanItems]

	OPEN IDs
	FETCH NEXT FROM IDs into @ID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @FatherElementID INT, @TotalChildrenCount INT, @CaseID INT, @WorkPlanID INT, @ItemVisualIndex INT
		SELECT @FatherElementID = [ParentID], @CaseID = CaseId, @WorkPlanID = WorkPlanId, @ItemVisualIndex = VisualIndex FROM [sma_TRN_WorkPlanItems] WHERE uId = @ID
		
		SELECT @TotalChildrenCount = COUNT(*) FROM [sma_TRN_WorkPlanItems] WHERE ParentID = @FatherElementID AND CaseId = @CaseID AND WorkPlanId = @WorkPlanID
		IF(@TotalChildrenCount > 1)
		BEGIN
			--NOW WE NEED TO ADVANCE THE INDEX NUMBER OF THIS ITEM
			IF(@ItemVisualIndex IN (SELECT VisualIndex FROM [sma_TRN_WorkPlanItems] WHERE ParentID = @FatherElementID AND CaseId = @CaseID AND WorkPlanId = @WorkPlanID AND uId <> @ID))
			BEGIN
				UPDATE [sma_TRN_WorkPlanItems]
				SET VisualIndex = (SELECT MAX(VisualIndex) FROM [sma_TRN_WorkPlanItems] WHERE ParentID = @FatherElementID AND CaseId = @CaseID AND WorkPlanId = @WorkPlanID) + 1
				WHERE uId = @ID
			END
		END

		FETCH NEXT FROM IDs into @ID
	END

	CLOSE IDs
	DEALLOCATE IDs

	GO

	update [sma_MST_WorkPlanItem] 
	SET [VisualIndex] = 1
	WHERE [VisualIndex] IS NULL OR [VisualIndex] = 0

	DECLARE @ID int
	DECLARE IDs CURSOR LOCAL FOR select [uId] from [sma_MST_WorkPlanItem]

	OPEN IDs
	FETCH NEXT FROM IDs into @ID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @FatherElementID INT, @TotalChildrenCount INT, @WorkPlanID INT, @ItemVisualIndex INT
		SELECT @FatherElementID = [ParentID], @WorkPlanID = WorkPlanId, @ItemVisualIndex = VisualIndex FROM [sma_MST_WorkPlanItem] WHERE uId = @ID
		
		SELECT @TotalChildrenCount = COUNT(*) FROM [sma_MST_WorkPlanItem] WHERE ParentID = @FatherElementID AND WorkPlanId = @WorkPlanID
		IF(@TotalChildrenCount > 1)
		BEGIN
			--NOW WE NEED TO ADVANCE THE INDEX NUMBER OF THIS ITEM
			IF(@ItemVisualIndex IN (SELECT VisualIndex FROM [sma_MST_WorkPlanItem] WHERE ParentID = @FatherElementID AND WorkPlanId = @WorkPlanID AND uId <> @ID))
			BEGIN
				UPDATE [sma_MST_WorkPlanItem]
				SET VisualIndex = (SELECT MAX(VisualIndex) FROM [sma_MST_WorkPlanItem] WHERE ParentID = @FatherElementID AND WorkPlanId = @WorkPlanID) + 1
				WHERE uId = @ID
			END
		END

		FETCH NEXT FROM IDs into @ID
	END

	CLOSE IDs
	DEALLOCATE IDs

	GO
