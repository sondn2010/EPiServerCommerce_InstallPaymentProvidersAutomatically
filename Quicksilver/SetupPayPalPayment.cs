using EPiServer.Business.Commerce.Payment.PayPal;
using EPiServer.Commerce.Internal.Migration.Steps;
using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAccess;
using EPiServer.Logging;
using EPiServer.Reference.Commerce.Site.Features.Checkout.Pages;
using EPiServer.Security;
using EPiServer.ServiceLocation;
using Mediachase.Commerce;
using Mediachase.Commerce.Core;
using Mediachase.Commerce.Markets;
using Mediachase.Commerce.Orders.Dto;
using Mediachase.Commerce.Orders.Managers;
using Mediachase.Commerce.Shared;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace EPiServer.Reference.Commerce.Site.Infrastructure
{
    [ServiceConfiguration(typeof(IMigrationStep))]
    public class SetupPayPalPayment : IMigrationStep
    {
        private IProgressMessenger _progressMessenger;

        private Injected<IContentRepository> _contentRepository;
        private Injected<IContentTypeRepository> _contentTypeRepository;
        private Injected<IPropertyDefinitionTypeRepository> _propertyDefinitionTypeRepository;
        private Injected<ITabDefinitionRepository> _tabDefinitionRepository;
        private Injected<IPropertyDefinitionRepository> _propertyDefinitionRepository;
        private Injected<IContentModelUsage> _contentModelUsage;
        private Injected<IMarketService> _marketService;

        private ContentType _startPageContentType;
        private PropertyDefinitionType _pageReferenceType;
        private TabDefinition _shortcutTab;

        public int Order
        {
            get
            {
                return new ImportSiteContent().Order + 50;
            }
        }

        public string Name { get { return "Setup payment providers for Quicksilver"; } }
        public string Description { get { return "Quicksilver - setup payment providers (PayPal, DIBS, DataCash)"; } }

        public bool Execute(IProgressMessenger progressMessenger)
        {
            _progressMessenger = progressMessenger;
            try
            {
                _progressMessenger.AddProgressMessageText("Installing PayPal", false, 0);
                InstallPayPalPaymentProvider();
                
                return true;
            }
            catch (Exception ex)
            {
                _progressMessenger.AddProgressMessageText("Setting up failed: " + ex.Message + "Stack trace:" + ex.StackTrace, true, 0);
                LogManager.GetLogger(GetType()).Error(ex.Message, ex.StackTrace);
                return false;
            }
        }

        private void InstallPayPalPaymentProvider()
        {
            var startPageData = DataFactory.Instance.GetPage(ContentReference.StartPage).CreateWritableClone();
            _startPageContentType = _contentTypeRepository.Service.Load(startPageData.ContentTypeID);
            _pageReferenceType = _propertyDefinitionTypeRepository.Service.List().FirstOrDefault(x => x.Name == "PageReference");
            _shortcutTab = _tabDefinitionRepository.Service.Load("Shortcut");

            var allMarkets = _marketService.Service.GetAllMarkets().Where(x => x.IsEnabled).ToList();
            foreach (var language in allMarkets.SelectMany(x => x.Languages).Distinct())
            {
                var paymentMethodDto = PaymentManager.GetPaymentMethods(language.TwoLetterISOLanguageName);

                if (!paymentMethodDto.PaymentMethod.Any(p => p.SystemKeyword.Equals("PayPal")))
                {
                    AddPaymentMethod(Guid.NewGuid(),
                        "PayPal",
                        "PayPal",
                        "PayPal",
                        "EPiServer.Business.Commerce.Payment.PayPal.Orders.PayPalPayment, EPiServer.Business.Commerce.Payment.PayPal",
                        "EPiServer.Business.Commerce.Payment.PayPal.PayPalPaymentGateway, EPiServer.Business.Commerce.Payment.PayPal",
                        false, 0, allMarkets, language, paymentMethodDto);
                }
            }

            AddPropertyToStartPage("PayPalPaymentPage");
            AddPropertyToStartPage("PayPalPaymentLandingPage");

            var contentType = _contentTypeRepository.Service.Load<OrderConfirmationPage>();
            var contentUsage = _contentModelUsage.Service.ListContentOfContentType(contentType).FirstOrDefault();
            if (contentUsage != null)
            {
                var orderConfirmationPageLink = contentUsage.ContentLink;
                startPageData.Property["PayPalPaymentLandingPage"].Value = orderConfirmationPageLink;
            }
            else
            {
                var orderConfirmationPage = _contentRepository.Service.GetDefault<OrderConfirmationPage>(ContentReference.StartPage).CreateWritableClone() as OrderConfirmationPage;
                orderConfirmationPage.Name = "Order confirmation page";
                var orderConfirmationPageLink = _contentRepository.Service.Save(orderConfirmationPage, SaveAction.Publish, AccessLevel.NoAccess);

                startPageData.Property["PayPalPaymentLandingPage"].Value = orderConfirmationPageLink;
            }

            contentType = _contentTypeRepository.Service.Load<PayPalPage>();
            contentUsage = _contentModelUsage.Service.ListContentOfContentType(contentType).FirstOrDefault();
            if (contentUsage != null)
            {
                startPageData.Property["PayPalPaymentPage"].Value = contentUsage.ContentLink;
            }
            else
            {
                var PayPalPage = _contentRepository.Service.GetDefault<PayPalPage>(ContentReference.StartPage).CreateWritableClone() as PayPalPage;
                PayPalPage.Name = "PayPal process page";
                var PayPalPageLink = _contentRepository.Service.Save(PayPalPage, SaveAction.Publish, AccessLevel.NoAccess);
                startPageData.Property["PayPalPaymentPage"].Value = PayPalPageLink;
            }

            _contentRepository.Service.Save(startPageData, SaveAction.Publish, AccessLevel.NoAccess);
        }
        
        private void AddPropertyToStartPage(string propertyName)
        {
            var startPageData = DataFactory.Instance.GetPage(ContentReference.StartPage);
            var startPageContentType = _contentTypeRepository.Service.Load(startPageData.ContentTypeID);
            if (!startPageContentType.PropertyDefinitions.Any(p => p.Name == propertyName))
            {
                var propertyItem = new PropertyDefinition();
                propertyItem.ContentTypeID = startPageContentType.ID;
                propertyItem.Name = propertyName;
                propertyItem.HelpText = propertyName;
                propertyItem.EditCaption = propertyName;
                propertyItem.Type = _pageReferenceType;
                propertyItem.Tab = _shortcutTab;

                _propertyDefinitionRepository.Service.Save(propertyItem);
            }
        }

        private static void AddPaymentMethod(Guid id, string name, string systemKeyword, string description, string implementationClass, string gatewayClass,
            bool isDefault, int orderIndex, IEnumerable<IMarket> markets, CultureInfo language, PaymentMethodDto paymentMethodDto)
        {
            var row = paymentMethodDto.PaymentMethod.AddPaymentMethodRow(id, name, description, language.TwoLetterISOLanguageName,
                            systemKeyword, true, isDefault, gatewayClass,
                            implementationClass, false, orderIndex, DateTime.Now, DateTime.Now, AppContext.Current.ApplicationId);

            var paymentMethod = new Mediachase.Commerce.Orders.PaymentMethod(row);
            paymentMethod.MarketId.AddRange(markets.Where(x => x.IsEnabled && x.Languages.Contains(language)).Select(x => x.MarketId));
            paymentMethod.SaveChanges();
        }
    }
}