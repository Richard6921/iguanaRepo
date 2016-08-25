-- The main function is the first function called from Iguana.
function main()
   -- read U of T json courses
   -- http://coursefinder.utoronto.ca/course-search/search/courseSearch/course/search?queryText=&requirements=&campusParam=St.%20George,Scarborough,Mississauga
   local f=io.open('/Users/rwang/ionicApps/uoft.json','r')
   local jsonData = f:read()
   f:close()
   local course = _G.json.parse{data=jsonData}
   trace(course.aaData[1])
   
   
   -- Convert Course List to CSV
   local a=io.open('/Users/rwang/ionicApps/uoftCourseList.csv','w+')
   a:write('Code,Course Name,Credits,Campus,Department,Term,Division,Days of Week,Course Level,Time\r\n')
   
   local index = 1
   local code
   local courseName
   local credits
   local campus
   local department
   local term
   local division
   local daysofweek
   local courseLevel
   local time
   local dataStr
   
   while index <= #course.aaData do
      code = course.aaData[index][2]:split('>')[2]:split('<')[1]
      courseName = course.aaData[index][3]:gsub(',', '')
      credits = course.aaData[index][4]:gsub(',', '')
      campus = course.aaData[index][5]:gsub(',', '')
      department = course.aaData[index][6]:gsub(',', '')
      term = course.aaData[index][7]:gsub(',', '')
      division = course.aaData[index][8]:gsub(',', '')
      daysofweek = course.aaData[index][9]:gsub(',', '')
      courseLevel = course.aaData[index][10]:gsub(',', '')
      time = course.aaData[index][11]:gsub(',', '')
      dataStr = code..','..courseName..','..credits..','..campus..','..department..','..term..','..division..','..daysofweek..','..courseLevel..','..time..'\r\n'
      trace(dataStr)
      
      a:write(dataStr)
      index = index + 1
   end
   
   a:close()
   
end
