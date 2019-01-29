note
	description: "[
		This utility class contains a merge sort and
		concatenate of two arrays.
		You must complete the TO DO parts
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	UTIL [G -> COMPARABLE]

feature -- queries

	concatenate (a: ARRAY [G]; b: ARRAY [G]): ARRAY [G]
		require
			constraints_on_lower_indices:
				-- Do not modify this precondition.
				a.lower = 1 and b.lower = 1

		local
			counter: INTEGER
		do
			create Result.make_empty
			-- TO DO

			counter := 1
			across
				a as j
			loop
				Result.force (j.item, counter)
				counter := counter + 1
			end

			across
				b as j
			loop
				Result.force (j.item, counter)
				counter := counter + 1
			end


		ensure
			constraint_on_lower_index:
				-- Do not modify this postcondition.
				Result.lower = 1

			correct_size:
				-- TO DO: replace False with your postcondition.
				Result.count = a.count + b.count

			correct_contents:
				-- TO DO: replace False with your postcondition.
				-- The final result must be the concatenation of
				-- the two argument arrays.
				-- Hint: You may use `across' as a universal quantifier.
				-- Plan: Check each element is contained in either a or b
				across
					1 |..| Result.count as i
				all
					a.has(Result[i.item]) or b.has(Result[i.item])
				end

		end

	merge (left, right: ARRAY[G]): ARRAY[G]
			-- Result is a sorted merge of `left' and `right'
		require
			left_sorted: True
				-- TO DO: replace False with your precondition.
				-- Plan: sorted means ordered. Use same code as 'sorted_non_descending'
				across
					1 |..| (left.count - 1) as i
				all
					left [i.item] < left [i.item + 1]
				end

			right_sorted: True
				-- TO DO: replace False with your precondition.
				across
					1 |..| (right.count - 1) as i
				all
					right [i.item] < right [i.item + 1]
				end
		local
			leftCursor: INTEGER
			rightCursor: INTEGER
			leftMax: INTEGER
			rightMax: INTEGER
			outOfIndex: BOOLEAN
			tempArray: ARRAY[G]
			tempArrayCounter: INTEGER
		do
			create Result.make_empty
			-- TO DO
			-- Plan:
			-- left and right, start from first index,
			-- compare left and right index and force to Result array if smaller

			leftCursor := 1
			rightCursor := 1
			leftMax := left.count
			rightMax := right.count
			outOfIndex := False	-- If one side if out of index, stop looping

			across
			 1 |..| (left.count + right.count) as mainCursor
			loop

				-- Before cmparison, need to check 'out of index'
				if outOfIndex = False then

					-- Create an Array (Starting from Cursor to the end)
					-- then Concat to Result

					if leftCursor > leftMax then
						--print("%NLeft cursor is out of index...")

						-- Create array
						tempArray := right.subarray(rightCursor, right.upper)
						tempArray.rebase (1)	-- for lower set. If not set, lower not be 1

						Result := concatenate(Result, tempArray)

						outOfIndex := True
						--displayCursorPos(mainCursor.item, leftCursor, rightCursor)

					elseif rightCursor > rightMax then
						--print("%NRight cursor is out of index...")

						-- Create array
						tempArray := left.subarray(leftCursor, left.upper)
						tempArray.rebase (1)	-- for lower set. If not set, lower not be 1

						Result := concatenate(Result, tempArray)

						outOfIndex := True
						--displayCursorPos(mainCursor.item, leftCursor, rightCursor)

					else

						-- Concat a single element (As an array) to the Result

						if left[leftCursor] < right[rightCursor] then

							Result := concatenate(Result, <<left[leftCursor]>>)

							leftCursor := leftCursor + 1

						else
							Result := concatenate(Result, <<right[rightCursor]>>)
							rightCursor := rightCursor + 1
						end
					end
				end

			end

		ensure
			merge_count:
				-- TO DO: replace False with your postcondition.
				-- Hint: What is the size of Result?
				Result.count = left.count + right.count

			sorted_non_descending:
				-- TO DO: replace False with your postcondition.
				-- Hint: Result is sorted in a non-descending order.
				across
					1 |..| (Result.count - 1) as i
				all
					Result [i.item] < Result [i.item + 1]
				end

			merge_contains_left_and_right:
				-- TO DO: replace False with your postcondition.
				-- Hint: The result only contains elements from `left' and `right'.
				across
					1 |..| Result.count as i
				all
					left.has(Result[i.item]) or right.has(Result[i.item])
				end

		end


	merge_sort(a: ARRAY[G]): ARRAY[G]
			-- reteurn a sorted version of array `a'
		local
			low, mid, high: INTEGER
			a1, a2: ARRAY[G]
		do

			create Result.make_from_array (a)
			low := a.lower
			high := a.upper

			if low < high then
				check a.count > 1 end
				mid := (low + high) // 2
				a1 := a.subarray (low, mid)
				a2 := a.subarray (mid + 1, high)
				a2.rebase (1)
				a1 := merge_sort (a1)
				a2 := merge_sort (a2)

				Result := merge (a1, a2)
			end
		ensure
			-- Plan: refer "sorted_keys" class in SORTED_MAP_ADT
			same_count:
				-- TO DO: replace False with your postcondition.
				-- Hint: What is the size of Result?
				Result.count = a.count

			sorted_non_descending:
				-- TO DO: replace False with your postcondition.
				-- Hint: Result is sorted in a non-descending order.
				across
					1 |..| (Result.count - 1) as i
				all
					Result [i.item] < Result [i.item + 1]
				end

			permutation:
				-- TO DO: replace False with your postcondition.
				-- Hint: You may want to use {ARRAY}occurrences
				across
					1 |..| Result.count as i
				all
					Result.occurrences(Result [i.item]) = 1
				end

		end


	displayArray(a: ARRAY[G])
		local
			counter: INTEGER
		do
			counter := 0

			across
				a as i
			loop
				counter := counter + 1
				print(i.item.out)
				if not (counter = a.count) then print(" ") end
			end
		end

	displayCursorPos(mainCursor,leftCursor,rightCursor: INTEGER)
		do
			print("%NCursor Pos: ")
			print("[Main: " + mainCursor.out + "]")
			print("[Left: " + leftCursor.out + "]")
			print("[Right: " + rightCursor.out + "]")

		end

end
