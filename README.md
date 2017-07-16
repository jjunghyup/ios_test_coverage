Xcode Test Coverage 측정을 위한 Shell Script

<hr>

□ 정보
- 대상언어 : Object-C, Swift
- 사전설치 프로그램 : Ruby
- 참조프로그램<br>
   . Xcpretty : https://github.com/supermarin/xcpretty <br>
   . Slather : https://github.com/SlatherOrg/slather <br>

<hr>

□ 실행법
- run_cov.sh파일을 Xcode 프로젝트 폴더에 복사한다.
- run_cov.sh를 Input Arguments(Project정보, Scheme정보)와 함께 수행한다.<br>
  실행) sh run_cov.sh <프로젝트 정보> <스키마정보> <br>
  예시) sh run_cov.sh Foo.xcodeproj Foo

□ 수행결과
- 정상 수행 후 JUnit과 Coverage결과를 Console에서 확인 가능하며, Report결과는 다음 위치에서 확인 할 수 있습니다.
- Report 결과위치<br>
  . JUnit : {수행위치}/build/report/ <br>
  . Coverage : {수행위치}/slather-report/
