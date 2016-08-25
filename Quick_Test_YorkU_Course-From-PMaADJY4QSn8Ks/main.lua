-- The main function is the first function called from Iguana.
function main()
   -- York University Website: https://coursecode.apps06.yorku.ca/
   -- fetch course criteria
   local searchData = net.http.get{url='https://coursecode.apps06.yorku.ca/getValids', live=true}
   local searchList = json.parse{data=searchData}.faculty_subjects
   
   -- construct course search web services header
   local postURL = 'https://coursecode.apps06.yorku.ca/asearch'
   local Headers = 
   {['Host']='coursecode.apps06.yorku.ca',
    ['Content-Type']='application/x-www-form-urlencoded; charset=UTF-8',
    ['X-Requested-With']='XMLHttpRequest',
    ['X-CSRFToken']='itX9U0HDuQdiXLE32XZ7yJpMa4xg0avy',
    ['Host']='coursecode.apps06.yorku.ca',
    ['Accept']='*/*',
    ['Accept-Encoding']='gzip, deflate',
    ['Accept-Language']='en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4',
    ['Connection']='keep-alive',  
    ['Origin']='https://coursecode.apps06.yorku.ca',
    ['Referer']='https://coursecode.apps06.yorku.ca/',
    ['User-Agent']='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36',          
    ['Cookie']='__insp_wid=1748088910; __insp_slim=1470711305606; __insp_nv=true; __insp_ref=aHR0cHM6Ly93d3cuZ29vZ2xlLmNhLw%3D%3D; __insp_targlpu=http%3A%2F%2Fcurrentstudents.yorku.ca%2F; __insp_targlpt=Home%20%7C%20Current%20Students%20%7C%20York%20University; __insp_norec_sess=true; _ga=GA1.2.1885794518.1468548030; csrftoken=itX9U0HDuQdiXLE32XZ7yJpMa4xg0avy'}
   
   -- Create CSV file
   local a=io.open('/Users/rwang/ionicApps/yorkUCourseList.csv','w+')
   a:write('Code,Course Name,Year,Faculty,Course Level,Section,Format,Group\r\n')
   
   -- Loop each faculty and each subject
   local facIndex = 1
   local subIndex = 1
   local subjectList, code, courseName,year,faculty,courseLevel,section,format,group,dataStr
   local Body, resultData, result
   
   while facIndex <= #searchList do
      subjectList = searchList[facIndex].subjects
      subIndex = 1
      while subIndex <= #subjectList do
         -- Fire service causer per faculty per subject
         Body = 'faculty='..searchList[facIndex].faculty..'&subject='..subjectList[subIndex]..'&course=&year=2016&csrftoken=itX9U0HDuQdiXLE32XZ7yJpMa4xg0avy'
         Headers['Content-Length'] = string.len(Body)
         util.sleep(200)
         resultData = net.http.post{url=postURL, headers=Headers, body=Body, live=true}
         result = json.parse{data=resultData} 
         
         if result.courses ~= nil then
            for index, res in ipairs(result.courses) do
               -- assign value
               code = res[5]..res[7]
               courseName = res[2]:gsub(',', '')
               year = res[3]
               faculty = GetFullFacultyName(res[4])
               courseLevel = res[6]
               section = res[8]
               format = res[9]
               group = res[10]

               -- write to file
               dataStr = code..','..courseName..','..year..','..faculty..','..courseLevel..','..section..','..format..','..group..'\r\n'
               a:write(dataStr)
            end
         end
         
         subIndex = subIndex + 1
      end
      facIndex = facIndex + 1
   end
   
   a:close()
   
end

function GetFullFacultyName(v)
    if     v == "AK" then return "Atkinson Faculty of Liberal & Professional Studies - (AK)"
    elseif v == "AP" then return "Faculty of Liberal Arts and Professional Studies - (AP)"
    elseif v == "AS" then return "Faculty of Arts - (AS)"
    elseif v == "ED" then return "Faculty of Education - (ED)"
    elseif v == "ES" then return "Faculty of Environmental Studies - (ES)"
    elseif v == "FA" then return "School of the Arts, Media, Performance and Design - (FA)"
    elseif v == "GL" then return "Collège universitaire Glendon - (GL)"
    elseif v == "GS" then return "Faculty of Graduate Studies - (GS)"
    elseif v == "HH" then return "Faculty of Health - (HH)"
    elseif v == "LE" then return "Lassonde School of Engineering - (LE)"
    elseif v == "LW" then return "Osgoode Hall Law School - (LW)"
    elseif v == "SB" then return "Schulich School of Business - (SB)"
    elseif v == "SC" then return "Faculty of Science - (SC)"
    else                  return v
    end
end