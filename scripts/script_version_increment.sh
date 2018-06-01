PREV_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}"`
NEW_VERSION=`git rev-list HEAD --count`
/usr/libexec/PListBuddy -c "Set :CFBundleVersion ${PREV_VERSION%.*}.$(($NEW_VERSION))" "${INFOPLIST_FILE}"
/usr/libexec/PListBuddy -c "Set :CFBundleShortVersionString ${PREV_VERSION%.*}.$(($NEW_VERSION))" "${INFOPLIST_FILE}"