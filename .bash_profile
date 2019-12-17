git()
{
  if [ $# -gt 0 ] && [ "$1" == "push" ] ; then
     shift
     command gitleaks --repo-path=. -v && git exitloop "$@"
  elif [ $# -gt 0 ] && [ "$1" == "exitloop" ] ; then
     shift
     command git push "$@"
  else
     command git "$@"
  fi
}
