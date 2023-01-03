# Contributing

---
## Code Contributions
---
코드를 작성하려면 다음 양식을 지켜야 합니다.
* [C++ Coding Style Guide](https://google.github.io/styleguide/cppguide.html) and
* [Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)

어떠한 수정이라도 [Pull requests](https://help.github.com/articles/using-pull-requests/) 를 요청하여야 합니다.
간단한 가이드는 다음과 같습니다.

1. [WCL](https://github.com/OneTop4458/WCL) repo [Fork](https://help.github.com/articles/fork-a-repo/) 를 합니다.

2. Fork 된 Repo는 [동기화](https://help.github.com/articles/syncing-a-fork/) 즉, 변경사항이 다른 사용자의 작업에 방해가 되거나 충돌하지 않음)을 보장하는 업스트림 기능을 제공합니다.  
[개발](https://github.com/OneTop4458/WCL/tree/devel) 지점은 현재 진행 중인 대부분의 개발이 이루어지는 곳입니다.  
새 기능 또는 버그 수정의 경우 명확한 이름으로 새 Brnach를 생성합니다.  
자세한 내용은 위에 언급된 [branching model](http://nvie.com/posts/a-successful-git-branching-model/)을 참고하십시오.

3. 코드 변경 사항을 작성하고 컴파일 가능한지 확인합니다.

4. 테스트의 경우(해당되는 경우) 테스트 코드를 작성하고 통과했는지 확인합니다.

5. 변경 사항에 대한 응용프로그램 테스트를 수행합니다. (최소한 주요 플랫폼에서는 테스트를 모두 수행하여야 합니다. (Linux, Windows 등))

6. 변경 사항에 대한 명확한 커밋 메시지와 함께 [Pull request](https://help.github.com/articles/using-pull-requests/)를 보냅니다.

중요 : `master` branch로 Pull requests를 보내지 마십시오.  
모든 요청은 `특정 릴리즈` branch 또는 `devel` branch를 대상으로 요청해야 합니다.

이후 다른 팀원은 요청된 Purll request 건에 대한 코드 리뷰나 의견을 제안하며 문제가 없다면 merge 합니다.

---
## CppLint
WCL에 포함된 C++ 코드는 [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)를 따르고 있습니다.그리고 이러한 코드 스타일을 체크하는 툴로 [cpplint](https://github.com/cpplint/cpplint)를 사용합니다.

아래와 같은 명령으로 cpplint를 실행하여 코드 스타일 검사 후 요청 바랍니다.
```
$ cpplint --extensions=h,hh,hpp,c,cc,cpp --linelength=100 WCL.hpp
WCL.hpp:20:  Include the directory when naming .h files  [build/include_subdir] [4]
WCL.hpp:70:  Lines should be <= 100 characters long  [whitespace/line_length] [2]
Done processing WCL.hpp
Total errors found: 2
```

cpplint는 아래와 같이 pip를 통해 설치할 수 있습니다.
```
pip install cpplint
```
git-pylint-commit-hook 처럼 아래와 같은 스크립트를 `git-cpplit-commit-hook`이라는 이름으로 PATH 환경변수 경로에 두고 `.git/hooks/pre-commit` 파일에 등록해 두면 편리합니다. (권고 사항)
```
#!/usr/bin/env bash

cpplint_cmd="cpplint --extensions=c,cc,cpp,h,hh,hpp --linelength=100"

has_err=0
for i in $(git diff-index --cached --name-only HEAD | grep -e \\.c$ -e \\.cc$ -e \\.cpp$ -e \\.h$ -e \\.hh$ -e \\.hpp$); do
    if [ -f ${i} ]; then
        ${cpplint_cmd} ${i} || has_err=1
    fi
done
exit ${has_err}
```
