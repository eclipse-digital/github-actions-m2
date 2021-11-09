#!/bin/ash
#setted values
set -e
test -z "${CE_VERSION}" || MAGENTO_VERSION=$CE_VERSION
test -z "${MODULE_DIR}" && MODULE_DIR=$INPUT_MODULE_DIR
test -z "${SATIS}" && SATIS=$INPUT_SATIS
test -z "${MARKETPLACE_LOGIN}" && (echo "'MARKETPLACE_LOGIN' is not set" && exit 1)
test -z "${MARKETPLACE_PASSWORD}" && (echo "'MARKETPLACE_PASSWORD' is not set" && exit 1)
test -z "${MODULE_NAME}" && (echo "'MODULE_NAME' is not set" && exit 1)
test -z "${VENDOR_NAME}" && (echo "'VENDOR_NAME' is not set" && exit 1)
test -z "${MAGENTO_VERSION}" && (echo "'MAGENTO_VERSION' is not set" && exit 1)
test -z "${MAGENTO_VERSION_TYPE}" && (echo "'MAGENTO_VERSION_TYPE' is not set" && exit 1)

if [[ "${PRIVATE_PACKEGIST}" == "true" ]] ; then
  test -z "${PRIVATE_REPO}" && (echo "'PRIVATE_REPO' is not set" && exit 1)
  test -z "${PRIVATE_LOGIN}" && (echo "'PRIVATE_LOGIN' is not set" && exit 1)
  test -z "${PRIVATE_PASSWORD}" && (echo "'PRIVATE_PASSWORD' is not set" && exit 1)
fi
#Script const
MG_REPOSITORY_URL='https://repo.magento.com/'
PROJECT_PATH=$GITHUB_WORKSPACE

composer global config http-basic.repo.magento.com $MARKETPLACE_LOGIN $MARKETPLACE_PASSWORD

if [[ "${PRIVATE_PACKEGIST}" == "true" ]] ; then
composer global config http-basic.PRIVATE_REPO $PRIVATE_LOGIN $PRIVATE_PASSWORD
fi

#Logic
echo 'Prepare magento composer project'
if [[ "${MAGENTO_VERSION_TYPE}" == "CE" ]] ; then
  composer create-project \
  --repository=$MG_REPOSITORY_URL \
  magento/project-enterprise-edition=${MAGENTO_VERSION} \
  $WEB_DIR --no-install --no-interaction --no-progress
else
  composer create-project \
  --repository=$MG_REPOSITORY_URL \
  magento/project-community-edition=${MAGENTO_VERSION} \
  $WEB_DIR --no-install --no-interaction --no-progress
fi

echo "Run installation"
cd $WEB_DIR
COMPOSER_MEMORY_LIMIT=-1 composer install --prefer-dist --no-interaction --no-progress --no-suggest

echo 'Prepare module'
mkdir -p $WEB_DIR/app/code/$VENDOR_NAME/$MODULE_NAME
cd $WEB_DIR/app/code/$VENDOR_NAME/
cp -R ${GITHUB_WORKSPACE}/${MODULE_SOURCE}* $MODULE_NAME

echo 'Prepare unit config'
cp /docker-files/phpunit.xml $WEB_DIR/dev/tests/unit/phpunit.xml

echo "Run the unit tests"
php $WEB_DIR/vendor/phpunit/phpunit/phpunit \
 -c $WEB_DIR/dev/tests/unit/phpunit.xml \
 --colors=always \
 $WEB_DIR/app/code/$VENDOR_NAME/$MODULE_NAME/Test/Unit/

