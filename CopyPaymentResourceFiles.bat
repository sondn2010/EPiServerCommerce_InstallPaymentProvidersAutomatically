@echo off
SET "commerceManagerFolder=C:\commerce\Sources\EPiServer.Reference.Commerce.Manager"
SET "samplesiteFolder=C:\commerce\Sources\EPiServer.Reference.Commerce.Site"
SET "paymentProjectFolder=C:\commerce\EPiServer.Business.Commerce.Payment.PayPal"

echo Start copying files PayPal backend files...

xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.PayPal.dll %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.PayPal.pdb %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Mediachase.WebConsoleLib.dll %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\PayPalCoreSDK.dll %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\PayPalMerchantSDK.dll %commerceManagerFolder%\bin\ /f /i /Y

xcopy %paymentProjectFolder%\CommerceManager\ConfigurePayment.ascx %commerceManagerFolder%\Apps\Order\Payments\Plugins\PayPal\ /f /i /Y
xcopy %paymentProjectFolder%\CommerceManager\EditTab.ascx %commerceManagerFolder%\Apps\Order\Payments\MetaData\PayPal\ /f /i /Y


echo Start copying files PayPal frontend files...

xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.PayPal.dll %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.PayPal.pdb %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Mediachase.WebConsoleLib.dll %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\PayPalCoreSDK.dll %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\PayPalMerchantSDK.dll %samplesiteFolder%\bin\ /f /i /Y

xcopy %paymentProjectFolder%\images\PayPal-logo.jpg %samplesiteFolder%\Style\Images\ /f /i /Y

xcopy %paymentProjectFolder%\lang %samplesiteFolder%\lang\ /f /i /Y

xcopy %paymentProjectFolder%\Frontend\_PaypalPaymentMethod.cshtml %samplesiteFolder%\Views\Shared\ /f /i /Y
xcopy %paymentProjectFolder%\Frontend\_PayPalConfirmation.cshtml %samplesiteFolder%\Views\Shared\ /f /i /Y

echo Copy PayPal done.



SET "paymentProjectFolder=C:\commerce\EPiServer.Business.Commerce.Payment.DIBS"

echo Start copying files DIBS backend files...

xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DIBS.dll %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DIBS.pdb %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Mediachase.WebConsoleLib.dll %commerceManagerFolder%\bin\ /f /i /Y

xcopy %paymentProjectFolder%\CommerceManager\ConfigurePayment.ascx %commerceManagerFolder%\Apps\Order\Payments\Plugins\DIBS\ /f /i /Y
xcopy %paymentProjectFolder%\CommerceManager\EditTab.ascx %commerceManagerFolder%\Apps\Order\Payments\MetaData\DIBS\ /f /i /Y


echo Start copying files DIBS frontend files...

xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DIBS.dll %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DIBS.pdb %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Mediachase.WebConsoleLib.dll %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\images\DIBS-logo.jpg %samplesiteFolder%\Style\Images\ /f /i /Y

xcopy %paymentProjectFolder%\lang %samplesiteFolder%\lang\ /f /i /Y

xcopy %paymentProjectFolder%\Frontend\_DIBSPaymentMethod.cshtml %samplesiteFolder%\Views\Shared\ /f /i /Y
xcopy %paymentProjectFolder%\Frontend\_DIBSConfirmation.cshtml %samplesiteFolder%\Views\Shared\ /f /i /Y

echo Copy DIBS done.



SET "paymentProjectFolder=C:\commerce\EPiServer.Business.Commerce.Payment.DataCash"

echo Start copying files DataCash backend files...

xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DataCash.dll %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DataCash.pdb %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Mediachase.WebConsoleLib.dll %commerceManagerFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Transaction.dll %commerceManagerFolder%\bin\ /f /i /Y

xcopy %paymentProjectFolder%\CommerceManager\ConfigurePayment.ascx %commerceManagerFolder%\Apps\Order\Payments\Plugins\DataCash\ /f /i /Y
xcopy %paymentProjectFolder%\CommerceManager\EditTab.ascx %commerceManagerFolder%\Apps\Order\Payments\MetaData\DataCash\ /f /i /Y


echo Start copying files DataCash frontend files...

xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DataCash.dll %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\EPiServer.Business.Commerce.Payment.DataCash.pdb %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Mediachase.WebConsoleLib.dll %samplesiteFolder%\bin\ /f /i /Y
xcopy %paymentProjectFolder%\bin\Debug\Transaction.dll %samplesiteFolder%\bin\ /f /i /Y

xcopy %paymentProjectFolder%\images\DataCash-logo.jpg %samplesiteFolder%\Style\Images\ /f /i /Y

xcopy %paymentProjectFolder%\lang %samplesiteFolder%\lang\ /f /i /Y

xcopy %paymentProjectFolder%\Frontend\_DataCashPaymentMethod.cshtml %samplesiteFolder%\Views\Shared\ /f /i /Y
xcopy %paymentProjectFolder%\Frontend\_DataCashConfirmation.cshtml %samplesiteFolder%\Views\Shared\ /f /i /Y


echo Copy DataCash done.



echo Config payment providers by .cs files
pause