<template>
  <q-page class="flex flex-center">
     <q-form
      autocorrect="off"
      autocapitalize="off"
      autocomplete="off"
      spellcheck="false"
      greedy
      @submit="onSubmit"
      @reset="onReset"
    >
      <q-card
        flat
        bordered
        style="width: 900px;"
      >
        <q-item>
          <q-item-section avatar>
            <img src="~assets/logo.png">
          </q-item-section>

          <q-item-section>
            <q-item-label>{{ $t('title') }}</q-item-label>
            <q-item-label caption>{{ $t('subtitle') }}</q-item-label>
          </q-item-section>
        </q-item>

        <q-separator />

        <q-card-section>
          <div class="q-mb-md">
            <q-file
              filled
              lazy-rules
              accept=".xml"
              counter
              v-model="model.modsXml"
              :label="`${$t('form.modsXml')}*`"
              :hint="$t('form.modsXmlHint')"
              :rules="[(val) => !!val || $t('form.validation.required')]"
              :counter-label="showSize"
            />
          </div>
          <div class="q-mb-md">
            <q-file
              filled
              lazy-rules
              accept=".xslt"
              counter
              v-model="model.collectionsXslt"
              :label="`${$t('form.collectionsXslt')}*`"
              :hint="$t('form.collectionsXsltHint')"
              :rules="[(val) => !!val || $t('form.validation.required')]"
              :counter-label="showSize"
            />
          </div>
          <div class="q-mb-md">
            <q-file
              filled
              lazy-rules
              accept=".xslt"
              counter
              v-model="model.licencesXslt"
              :label="`${$t('form.licencesXslt')}*`"
              :hint="$t('form.licencesXsltHint')"
              :rules="[(val) => !!val || $t('form.validation.required')]"
              :counter-label="showSize"
            />
          </div>
        </q-card-section>

        <q-card-actions>
          <q-btn
            :label="$t('form.submit')"
            type="submit"
            color="primary"
          />
          <q-btn
            :label="$t('form.reset')"
            type="reset"
            color="primary"
            flat
            class="q-ml-sm"
          />
          <q-space />
          <q-btn
            type="a"
            flat
            text-color="primary"
            @click="onContact"
          >
            {{ $t('contact') }}
          </q-btn>
        </q-card-actions>
      </q-card>

    </q-form>

    <XmlDialog
      v-model="showDialog"
      :xml="transformedXml"
      @close="onCancel"
    />
  </q-page>
</template>

<script>
import { defineComponent, ref, toRaw } from 'vue';
import { useI18n } from 'vue-i18n';
import { openURL } from 'quasar';
import { transformXML } from 'src/helpers';
import XmlDialog from 'src/components/XmlDialog.vue';

export default defineComponent({
  components: { XmlDialog },
  setup() {
    const { t } = useI18n();
    const model = ref({
      modsXml: null,
      collectionsXslt: null,
      licencesXslt: null,
    });
    const showDialog = ref(false);
    const transformedXml = ref('');

    const onSubmit = () => {
      const files = toRaw(model.value);
      transformXML(files)
        .then((xmlString) => {
          transformedXml.value = xmlString;
          showDialog.value = true;
        });
    };

    const onReset = () => {
      model.value = {
        modsXml: null,
      };
    };

    const onCancel = () => {
      showDialog.value = false;
      transformXML.value = '';
      onReset();
    };

    const showSize = ({ totalSize }) => totalSize;

    const onContact = () => openURL(
      t('contactMailTo'),
    );

    return {
      model,
      onSubmit,
      onReset,
      showSize,
      onCancel,
      onContact,
      showDialog,
      transformedXml,
    };
  },
});
</script>
